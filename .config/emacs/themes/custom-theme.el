(deftheme custom "Custom theme")

(let ((background "#282c34")
      (foreground "#d7d7d7")
      (keyword-blue "#87afd7")
      (string-red "#F34F57")
      (comment-green "#98be65")
      (constant-yellow "#d8d895")
      (preproc-brown "#B5835A")
      (org-source-code-light-gray "#808080"))
  (custom-theme-set-faces
   'custom

   ;; Basic text
   `(default ((t (:foreground ,foreground :background ,background))))
   `(cursor ((t (:background ,foreground))))
   `(region ((t (:background "#005f87"))))
   `(hl-line ((t (:background "#338cc6"))))       ;; Vim CursorLine
   `(shadow ((t (:foreground "#585858"))))        ;; NonText / SpecialKey

   ;; Line numbers / separators
   `(line-number ((t (:foreground "#555555" :background ,background))))            ;; LineNr
   `(line-number-current-line ((t (:foreground "#afafaf" :background "#444444")))) ;; CursorLineNr
   `(fringe ((t (:background ,background))))
   `(vertical-border ((t (:foreground ,foreground :background ,background))))

   ;; Syntax
   `(font-lock-variable-name-face ((t (:foreground ,foreground))))     ;; Identifier
   `(font-lock-function-name-face ((t (:foreground ,foreground))))     ;; Function names
   `(font-lock-type-face ((t (:foreground ,foreground))))              ;; Type

   ;; Colors I usually use
   `(font-lock-comment-face ((t (:foreground ,comment-green))))        ;; Comment
   `(font-lock-string-face ((t (:foreground ,string-red))))            ;; String
   `(font-lock-keyword-face ((t (:foreground ,keyword-blue))))         ;; Statement
   `(font-lock-constant-face ((t (:foreground ,constant-yellow))))     ;; Constant / Special
   `(font-lock-number-face ((t (:foreground ,constant-yellow))))       ;; Numbers
   `(font-lock-preprocessor-face ((t (:foreground ,preproc-brown))))   ;; PreProc

   ;; UI (modeline, prompts, tabs)
   `(mode-line ((t (:foreground "#b2b2b2" :background nil :box nil))))
   `(mode-line-inactive ((t (:foreground "#767676" :background nil :box nil))))
   `(minibuffer-prompt ((t (:foreground ,foreground))))
   `(header-line ((t (:foreground "#acacac" :background "#444444"))))

   ;; Org inline code (=like this=)
   `(org-code ((t (:foreground ,org-source-code-light-gray))))
   ;; Org verbatim (~like this~)
   `(org-verbatim ((t (:foreground ,org-source-code-light-gray))))
   
   ;; Make the fringe same as background
   `(fringe ((t (:background ,background))))
   ;; Make vertical borders same as background
   `(vertical-border ((t (:foreground ,foreground :background nil))))
   ;; For Emacs 25+ with pixel-precise dividers
   `(window-divider ((t (:foreground nil :background nil))))
   `(window-divider-first-pixel ((t (:foreground nil :background nil))))
   `(window-divider-last-pixel  ((t (:foreground nil :background nil))))

   ;; Menus / popups
   `(popup-tip-face ((t (:foreground "#121212" :background "#b2b2b2")))) ; approximate Pmenu
   `(icomplete-first-match ((t (:foreground ,foreground :background "#585858")))) ; PmenuSel-like

   ;; Search / parens
   `(isearch ((t (:foreground "#262626" :background "#ffd787"))))        ;; Search
   `(lazy-highlight ((t (:foreground "#262626" :background "#87d7ff")))) ;; IncSearch
   `(show-paren-match ((t (:background "#5f8787" :weight bold))))        ;; MatchParen
   `(show-paren-mismatch ((t (:foreground "#262626" :background "#ff8787"))))

   ;; Diff
   `(diff-added   ((t (:background "#405040" :foreground nil))))
   `(diff-removed ((t (:background "#504040" :foreground nil))))
   `(diff-changed ((t (:background "#605040" :foreground nil))))
   `(diff-refine-added   ((t (:background "#405040" :foreground ,foreground))))
   `(diff-refine-changed ((t (:background "#605040" :foreground "#e0b050"))))

   ;; Messages / statuses
   `(success ((t (:foreground "#35D087"))))   ;; MoreMsg
   `(warning ((t (:foreground "#F7D940"))))   ;; WarningMsg
   `(error   ((t (:foreground "#F15B62"))))   ;; ErrorMsg
   ))

(provide-theme 'custom)
