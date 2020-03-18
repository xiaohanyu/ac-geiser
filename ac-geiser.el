;;; ac-geiser.el --- Emacs auto-complete backend for geiser.

;; Copyright (C) 2013-2020  Xiao Hanyu <xiaohanyu1988@gmail.com>

;;; Commentary:

;; Provides one auto-complete source for Scheme projects using geiser.

;;; Usage:

;;     (require 'ac-geiser)
;;     (add-hook 'geiser-mode-hook 'ac-geiser-setup)
;;     (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
;;     (eval-after-load "auto-complete"
;;       '(add-to-list 'ac-modes 'geiser-repl-mode))
;;

;; Code goes here

(eval-when-compile (require 'cl))
(require 'geiser)
(require 'auto-complete)

(defun ac-source-geiser-candidates ()
  "Return a possibly-empty list of completions for the symbol at point."
  (when (geiser-repl--live-p)
    (geiser-completion--complete ac-prefix nil)))

(defun ac-geiser-documentation (symbol-name)
  (let ((ds (geiser-doc--get-docstring
             (make-symbol (substring-no-properties symbol-name))
             nil)))
    (concat
     (geiser-autodoc--str* (cdr (assoc "signature" ds)))
     "\n----\n"
     (or (cdr (assoc "docstring" ds)) ""))))

;;;###autoload
(defvar ac-source-geiser
  '((candidates . ac-source-geiser-candidates)
    (symbol . "g")
    (document . ac-geiser-documentation))
  "Source for geiser completion")

;;;###autoload
(defun ac-geiser-setup ()
  "Add the geiser completion source to the front of `ac-sources'.
This affects only the current buffer."
  (interactive)
  (add-to-list 'ac-sources
               'ac-source-geiser))

(provide 'ac-geiser)
;;; ac-geiser.el ends here
