;;; -*- lexical-binding: t; -*-
(setq custom-file "~/.config/emacs/custom.el")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

;; Packages
(use-package bluetooth :ensure t)

(defun my/mpv-open (url &optional _new-window)
  "Open URL in mpv instead of a browser."
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process "mpv" nil "mpv" url))
(setq browse-url-handlers '(("youtube\\.com\\|youtu\\.be" . my/mpv-open)))

(use-package org
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)))

;; Org capture templates from https://orgmode.org/manual/Capture-templates.html
;; TODO: Make this load from a template directory
(setq org-directory (expand-file-name "~/notes.org/")
      org-default-notes-file (concat org-directory "captures.org")
      org-capture-templates
      `(("t" "Todo" entry (file+headline ,(concat org-directory "test.org") "Tasks")
         "** TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n  %a")
        ("j" "Journal" entry (file+datetree ,(concat org-directory "journal.org"))
         "* %T\n  %?\n  %a")
	("b" "Bookmark" entry (file+headline ,(concat org-directory "test.org") "Bookmarks")
         "** [[%i][%?]]\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n")
	("c" "Raw Capture" entry (file+headline ,(concat org-directory "captures.org") "Captures")
	 "** Captured %U\n%i\n" :empty-lines 1 :immediate-finish t)))

;; Only show capture buffer in single capture window
(add-hook 'org-capture-mode-hook
          (lambda ()
            (when (equal (frame-parameter nil 'name) "Org Capture")
              (delete-other-windows))))

;; Close the capture window when finished
(add-hook 'org-capture-after-finalize-hook
          (lambda ()
            (when (equal "Org Capture" (frame-parameter nil 'name))
              (delete-frame))))

(use-package clojure-mode :ensure t)
(use-package slime :ensure t)

(use-package magit :ensure t)

(use-package elfeed
  :ensure t
  :bind
  (("C-x w" . elfeed)))
(use-package elfeed-goodies
  :ensure t
  :config
  (elfeed-goodies/setup))
(use-package elfeed-org
  :ensure t
  :after (elfeed org)
  :config
  (elfeed-org))
(setq rmh-elfeed-org-files (list "~/notes.org/RSS Feeds.org"))

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

(defun my/mpv-open (url &optional _new-window)
  "Open URL in mpv instead of a browser."
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process "mpv" nil "mpv" url))

(setq browse-url-handlers '(("youtube\\.com\\|youtu\\.be" . my/mpv-open)))

(unless (eq system-type 'darwin) (menu-bar-mode -1)) ;; Mac's menu bar is always at the top and looks awkward if it's blank
(tool-bar-mode -1)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(blink-cursor-mode 0)
(global-auto-revert-mode t)

; Line wraping
(global-visual-line-mode t) ; Soft-wrap lines

(ido-mode 1)
; (ido-everywhere 1)

(when (file-exists-p custom-file)
  (load-file custom-file))
