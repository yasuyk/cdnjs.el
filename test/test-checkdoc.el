(add-to-list 'load-path default-directory)
(defvar cdnjs-el "cdnjs.el")

;; test byte-comple
(mapc #'byte-compile-file `(,cdnjs-el))

;; test checkdoc
(with-current-buffer (find-file-noselect cdnjs-el)
    (let ((checkdoc-diagnostic-buffer "*warn*"))
      (checkdoc-current-buffer t)))
