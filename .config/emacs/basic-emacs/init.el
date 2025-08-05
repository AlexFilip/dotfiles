;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")

(defun some (fn list)
  "CUSTOM implementation of some"
  (let ((f (if (symbolp fn)
	       (symbol-function fn)
	     fn)))
    (if (funcall f (car list))
	t
      (some f (cdr list)))))

(defun all (fn list)
  "CUSTOM implementation of all"
  (let ((f (if (symbolp fn)
	       (symbol-function fn)
	     fn)))
    (if (funcall f (car list))
	(all f (cdr list))
      t)))

(defun require-pkg (package-name)
  (unless (package-installed-p package-name)
    (package-refresh-contents)
    (package-install package-name))
  (require package-name))

(defun require-pkgs (&rest package-names)
  (unless (all 'package-installed-p package-names)
      (progn
	(package-refresh-contents)
	(dolist (pkg package-names)
	  (unless (package-installed-p pkg)
	    (package-install pkg)))))
  (dolist (pkg package-names) (require pkg)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

(require-pkgs 'naysayer-theme 'gruber-darker-theme)
(load-theme 'naysayer t)

(add-to-list 'custom-theme-load-path (expand-file-name "~/.config/emacs/themes/"))

(setq auto-save-file-directory "~/.local/emacs-saves/")
(make-directory auto-save-file-directory t)
(setq auto-save-file-name-transforms `(("." ,auto-save-file-directory t)))

(setq backup-directory-alist `(("." . auto-save-file-directory)))
(setq backup-by-copying t)

(setq-default
 inhibit-startup-message t
 inhibit-startup-screen t
 initial-scratch-message nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(when (file-exists-p custom-file)
  (load-file custom-file))
