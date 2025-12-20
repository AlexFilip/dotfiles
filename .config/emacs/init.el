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
   ("C-c c" . org-capture))

  :config
  (let ((captures-file  "00 - Captures.org")
		(reminders-file "01 - Reminders.org")
		(todo-file      "02 - TODO.org")
		(journal-file   "Journal.org"))
	(setq org-directory (expand-file-name "~/notes.org/shared/")
		  org-default-notes-file (concat org-directory captures-file)
		  org-capture-templates
		  `(("t" "Todo" entry (file+headline ,(concat org-directory reminders-file) "Tasks")
			 "** TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n  %a")

			("j" "Journal" entry (file+datetree ,(concat org-directory journal-file))
			 "* %T\n  %?\n  %a")

			("b" "Bookmark" entry (file+headline ,(concat org-directory captures-file) "Bookmarks")
			 "** [[%i][%?]]\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n")

			("c" "Raw Capture" entry (file+headline ,(concat org-directory captures-file) "Captures")
			 "** Captured %U\n%i\n" :empty-lines 1 :immediate-finish t)

			("i" "Idea" entry (file+headline ,(concat org-directory captures-file) "Captures")
			 "** %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n"))))

  ;; Org capture templates from https://orgmode.org/manual/Capture-templates.html
  :hook
  ;; Only show capture buffer in single capture window
  ((org-capture-mode . (lambda ()
						 (when (equal (frame-parameter nil 'name) "Org Capture")
						   (delete-other-windows))))
   ;; Close the capture window when finished
   (org-capture-after-finalize . (lambda ()
								   (when (equal "Org Capture" (frame-parameter nil 'name))
									 (delete-frame))))))

(use-package clojure-mode :ensure t)
(use-package slime :ensure t)

(use-package magit :ensure t)

(use-package elfeed
  :ensure t
  :bind
  (("C-x w" . elfeed)))

(use-package elfeed-goodies
  :ensure t
  :after (elfeed)
  :config
  (elfeed-goodies/setup))

(use-package elfeed-org
  :ensure t
  :after (elfeed org)
  :config
  (elfeed-org))

(use-package org-mpv-notes
  :ensure t
  :commands (org-mpv-notes-mode org-mpv-notes-open)
  :hook (org-mode . org-mpv-notes-setup-link))

(use-package mpv
  :pin melpa
  :ensure t)

(use-package elfeed-tube
  :ensure t
  :after elfeed
  :demand t
  :config
  ;; (setq elfeed-tube-auto-save-p nil) ; default value
  ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
			  ("F" . elfeed-tube-fetch)
			  ([remap save-buffer] . elfeed-tube-save)
			  :map elfeed-search-mode-map
			  ("F" . elfeed-tube-fetch)
			  ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  :ensure t
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

(setq rmh-elfeed-org-files (list "~/notes.org/RSS-Feeds.org"))

;; Theming
;; (add-to-list 'custom-theme-load-path themes-dir)
;; (load-theme 'custom t)

;; NOTE: These are the colors defined by nord itself
;; TODO: Try to find out how to use the ones defined in the package itself
(defconst nord0 "#2E3440")
(defconst nord1 "#3B4252")
(defconst nord2 "#434C5E")
(defconst nord3 "#4C566A")
(defconst nord4 "#D8DEE9")
(defconst nord5 "#E5E9F0")
(defconst nord6 "#ECEFF4")
(defconst nord7 "#8FBCBB")
(defconst nord8 "#88C0D0")
(defconst nord9 "#81A1C1")
(defconst nord10 "#5E81AC")
(defconst nord11 "#BF616A")
(defconst nord12 "#D08770")
(defconst nord13 "#EBCB8B")
(defconst nord14 "#A3BE8C")
(defconst nord15 "#B48EAD")

(defun apply-nord-theme (&optional frame)
  "Custom tweaks to the Nord theme."
  ;; Only apply Nord once globally
  (with-selected-frame (or frame (selected-frame))
                       (unless (custom-theme-enabled-p 'nord)
                         (load-theme 'nord t)))
  (custom-set-faces
    `(font-lock-comment-face ((t (:foreground ,nord14))))
    `(font-lock-comment-delimiter-face ((t (:foreground ,nord14))))

    `(font-lock-string-face ((t (:foreground ,nord11))))
    `(font-lock-doc-face ((t (:foreground ,nord11))))

    `(region ((t (:background ,nord10))))))

(use-package nord-theme
             :ensure t
             :init
             (if (daemonp)
               (add-hook 'after-make-frame-functions #'apply-nord-theme)
               (apply-nord-theme))
             (add-hook 'tty-setup-hook #'apply-nord-theme))

(set-frame-font "Hack 12" nil t)

;; Settings
(defun my-go-mode-hook ()
  "Customizations for Go mode."
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  (when (boundp 'go-ts-mode-indent-offset)
    (setq go-ts-mode-indent-offset tab-width)))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Insert creation date on new headings
(add-hook 'org-insert-heading-hook
		  (lambda()
			(save-excursion
              (org-back-to-heading)
              (org-set-property "CREATED" (org-format-time-string (org-time-stamp-format t t))))))

(let ((backup-file-directory "~/.local/emacs-saves/")
      (auto-save-file-directory temporary-file-directory))
  (make-directory backup-file-directory t)
  (setq
   auto-save-file-name-transforms `(("." ,auto-save-file-directory t))
   auto-save-no-message t
   auto-save-default nil
   backup-directory-alist `(("." . ,backup-file-directory))
   backup-by-copying t))

(setq-default
 tab-width 4
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
