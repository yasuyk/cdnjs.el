
EMACS ?= emacs
CASK ?= cask
SRC ?= cdnjs.el
TEST_PACKAGE_INSTALL_EL ?=  test/test-package-install.el
TEST_PACKAGE_INSTALL_LOG ?=  test/test-package-install.log
LOADPATH = -L .
ELPA_DIR = $(shell EMACS=$(EMACS) $(CASK) package-directory)

.PHONY : test
test: test-package-install

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

.PHONY : test-package-install
test-package-install: elpa clean-package-install
	@echo "-- test install package --"
	$(CASK) exec $(EMACS) -batch -Q $(LOADPATH) -l $(TEST_PACKAGE_INSTALL_EL) 2>&1  | tee $(TEST_PACKAGE_INSTALL_LOG)
	@grep Error $(TEST_PACKAGE_INSTALL_LOG) && exit 1 || exit 0

.PHONY : clean-package-install
clean-package-install:
	rm -rf $(ELPA_DIR)/helm-git-grep*
	rm -rf $(TEST_PACKAGE_INSTALL_LOG)

.PHONY : travis-ci
travis-ci: print-deps test-package-install test

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
