;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")
(load-file custom-file)

(defun require-pkg (package-name)
  (unless (package-installed-p package-name)
    (package-refresh-contents)
    (package-install package-name))
  (require package-name))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

(require-pkg 'naysayer-theme)
(require-pkg 'gruber-darker-theme)
(load-theme 'naysayer t)

(add-to-list 'custom-theme-load-path (expand-file-name "~/.config/emacs/themes/"))

(setq auto-save-file-directory "~/.local/emacs-saves/")
(make-directory auto-save-file-directory t)
(setq auto-save-file-name-transforms `(("." ,auto-save-file-directory t)))

(setq backup-directory-alist `(("." . auto-save-file-directory)))
(setq backup-by-copying t)

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
