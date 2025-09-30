;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

;; Packages
(use-package bluetooth :ensure t)

(use-package clojure-mode :ensure t)
(use-package slime :ensure t)

(use-package magit :ensure t)

(use-package elfeed :ensure t)
(use-package elfeed-org :ensure t)
;; Theming
(add-to-list 'custom-theme-load-path (expand-file-name "~/.config/emacs/themes/"))
(load-theme 'custom t)

;; Settings
(let ((backup-file-directory "~/.local/emacs-saves/")
      (auto-save-file-directory temporary-file-directory))
  (make-directory backup-file-directory t)
  (setq auto-save-file-name-transforms `(("." ,auto-save-file-directory t)))
  (setq auto-save-no-message t)
  (setq auto-save-default nil)
  (setq backup-directory-alist `(("." . ,backup-file-directory)))
  (setq backup-by-copying t))

(setq-default
 inhibit-startup-message t
 inhibit-startup-screen t
 initial-scratch-message nil
 ring-bell-function 'ignore)

(setq
 auto-revert-verbose nil)

(unless (eq system-type 'darwin) (menu-bar-mode -1)) ;; Mac's menu bar is always at the top and looks awkward if it's blank
(tool-bar-mode -1)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(blink-cursor-mode 0)
(global-auto-revert-mode t)

; Line wraping
(global-visual-line-mode t) ; Soft-wrap lines

(ido-mode 1)
; (ido-everywhere 1)

;; Org-mode
(setq org-directory (expand-file-name "~/notes.org/"))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Org capture templates from https://orgmode.org/manual/Capture-templates.html
;; TODO: Make this load from a template directory
(setq org-default-notes-file (concat org-directory "captures.org")
      org-capture-templates
      `(("t" "Todo" entry (file+headline ,(concat org-directory "test.org") "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree ,(concat org-directory "journal.org"))
         "* %?\nEntered on %U\n  %i\n  %a")
	("b" "Bookmark" entry (file+headline ,(concat org-directory "test.org") "Bookmarks")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)))


(when (file-exists-p custom-file)
  (load-file custom-file))
