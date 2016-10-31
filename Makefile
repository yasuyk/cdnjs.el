
EMACS ?= emacs
CASK ?= cask
SRC ?= cdnjs.el
TEST_CHECKDOC_EL ?=  test/test-checkdoc.el
TEST_CHECKDOC_LOG ?=  test/test-checkdoc.log
TEST_PACKAGE_INSTALL_EL ?=  test/test-package-install.el
TEST_PACKAGE_INSTALL_LOG ?=  test/test-package-install.log
LOADPATH = -L .
ELPA_DIR = $(shell EMACS=$(EMACS) $(CASK) package-directory)

INIT_PACKAGE_EL="(progn (require 'cask) (cask-initialize \".\"))"

.PHONY : test
test: test-checkdoc package-lint test-package-install

.PHONY : travis-ci
travis-ci: print-deps package-lint test-package-install

.PHONY : unit-tests
# `clean-elc` task needs to remove byte-compiled files to collect coverage by undercover.el.
unit-tests: clean-elc elpa
	@echo "-- Running unit-tests --"
	${CASK} exec ert-runner

.PHONY : clean-elpa
clean-elpa:
	rm -rf .cask

.PHONY : clean-elc
clean-elc:
	cask clean-elc

.PHONY : clean
clean: clean-elpa clean-elc

.PHONY : print-deps
print-deps:
	${EMACS} --version
	@echo CASK=${CASK}

.PHONY : test-checkdoc
test-checkdoc: elpa
	@echo "-- test ckeckdoc --"
	$(CASK) exec $(EMACS) -batch -Q $(LOADPATH) -l $(TEST_CHECKDOC_EL) 2>&1 | tee $(TEST_CHECKDOC_LOG)
	@cat $(TEST_CHECKDOC_LOG) | [ $$(wc -l) -gt 0 ] && exit 1 || exit 0


.PHONY : package-lint
package-lint: elpa clean-package-install
	@echo "-- package lint --"
	$(CASK) exec $(EMACS) -batch -Q --eval $(INIT_PACKAGE_EL) -l package-lint.el -f package-lint-batch-and-exit $(SRC)

.PHONY : test-package-install
test-package-install: elpa clean-package-install
	@echo "-- test install package --"
	$(CASK) exec $(EMACS) -batch -Q $(LOADPATH) -l $(TEST_PACKAGE_INSTALL_EL) 2>&1  | tee $(TEST_PACKAGE_INSTALL_LOG)
	@grep Error $(TEST_PACKAGE_INSTALL_LOG) && exit 1 || exit 0

.PHONY : clean-package-install
clean-package-install:
	rm -rf $(TEST_PACKAGE_INSTALL_LOG)

.PHONY : elpa
elpa: $(ELPA_DIR)

$(ELPA_DIR): Cask
	$(CASK) install
	touch $@

.PHONY : check-coveralls-token
check-coveralls-token:
    ifdef COVERALLS_REPO_TOKEN
		@true
    else
		@echo COVERALLS_REPO_TOKEN is undefined
		@false
    endif

.PHONY : clean-coveralls-report
clean-coveralls-report: check-coveralls-token
	@( [ -f /tmp/undercover_coveralls_report ] && rm /tmp/undercover_coveralls_report ) || :

.PHONY : coveralls
coveralls: clean-coveralls-report unit-tests
