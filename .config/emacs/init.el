;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")
(load-file custom-file)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(add-to-list 'custom-theme-load-path (expand-file-name "~/.config/emacs/themes/"))

(setq auto-save-file-name-transforms `((".", "~/.local/emacs-saves" t)))
(setq backup-directory-alist `(("." . "~/.local/emacs-saves")))
(setq backup-by-copying t)

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
