;;; init.el --- Configuration

;;; Commentary:

;;; Code:

;; Package repositories
;; default: ("gnu" . "http://elpa.gnu.org/packages/")
(require 'package)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))


;; Manually installed packages
(add-to-list 'load-path "~/.emacs.d/vendor")
(let ((default-directory  "~/.emacs.d/vendor/"))
  (normal-top-level-add-subdirs-to-load-path))


;; Character Encoding
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;; Saving
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-default nil)
(require 'recentf)
(setq recentf-save-file "~/.emacs.d/.recentf")
(recentf-mode 1)
(setq recentf-max-menu-items 40)


;; UI tweaks
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(show-paren-mode 1)
(global-linum-mode 1)
(global-hl-line-mode 1)
(set-face-attribute 'default nil :height 120)
(blink-cursor-mode 0)
;; full path in title bar
(setq-default frame-title-format "%b (%f)")
(fset 'yes-or-no-p 'y-or-n-p)
(setq column-number-mode t)


;; Keyboard
;;
;; Disable CMD-z minimizing Emacs:
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;; Bind Home & End keys only on MacOS.  This would work when using a
;; standard keyboard.
(when (string= system-type "darwin")
  (global-set-key (kbd "<home>") 'beginning-of-line)
  (global-set-key (kbd "<end>") 'end-of-line))


;; Formatting
(setq-default indent-tabs-mode nil)
(setq-default fill-column 78)


;; Date/Time
(setq-default calendar-week-start-day 1
	      display-time-mail-string ""
	      display-time-24hr-format t)
(setq display-time-day-and-date t
      holiday-christian-holidays nil
      holiday-islamic-holidays nil
      holiday-bahai-holidays nil
      holiday-hebrew-holidays nil
      holiday-oriental-holidays nil
      holiday-solar-holidays nil
      holiday-general-holidays nil)


;; Elisp / Scheme
;; eldoc-mode shows documentation in the minibuffer when writing code
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)


;; Custom
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load-file custom-file))


;; IBuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Themes
;;   dracula-theme
;;   flatland-theme
(use-package dracula-theme
  :ensure t
  :config
  (set-face-attribute 'linum nil :height 100))


(use-package cargo
  :ensure t
  :init
  (setq-default cider-repl-history-file "~/.emacs.d/cider-history"
                cider-repl-wrap-history t))


(use-package cider
  :ensure t
  :config
  (setq-default org-babel-clojure-backend 'cider
                org-babel-clojure-sync-nrepl-timeout 5000))


(use-package clj-refactor
  :ensure t
  :init
  (setq-default cljr-inject-dependencies-at-jack-in nil)
  (add-hook 'clojure-mode-hook
	    (lambda ()
	      (clj-refactor-mode 1)
	      (yas-minor-mode 1) ; for adding require/use/import statements
	      ;; This choice of keybinding leaves cider-macroexpand-1 unbound
	      (cljr-add-keybindings-with-prefix "C-c C-m"))))


(use-package clojure-mode
  :ensure t
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode))


(use-package clojure-mode-extra-font-locking
  :ensure t)


(use-package company
  :ensure t
  :defer t
  :init
  (setq company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-tooltip-align-annotations t)
  :config
  (global-company-mode))


(use-package default-text-scale
  :ensure t
  :config
  (default-text-scale-mode))


(use-package edit-indirect
  :ensure t)


(use-package elm-mode
  :ensure t
  :init
  (setq elm-format-on-save t)
  (setq elm-sort-imports-on-save t)
  (setq elm-tags-on-save t)
  (setq elm-tags-exclude-elm-stuff nil))


(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package flycheck
  :ensure t
  :commands flycheck-mode
  :config
  (global-flycheck-mode)
  (setq flycheck-emacs-lisp-load-path 'inherit)
  (setq flycheck-global-modes '(not org-mode)))


(use-package flycheck-clojure
  :ensure t
  :config
  (eval-after-load 'flycheck '(flycheck-clojure-setup)))


(use-package flycheck-elm
  :ensure t
  :init
  (add-hook 'flycheck-mode-hook #'flycheck-elm-setup))


(use-package flycheck-ghcmod
  :ensure t)


(use-package flycheck-haskell
  :ensure t
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-haskell-setup))


(use-package flycheck-ledger
  :ensure t)


(use-package flycheck-rust
  :ensure t)


(use-package golden-ratio-scroll-screen
  :ensure t
  :config
  (global-set-key [remap scroll-down-command] 'golden-ratio-scroll-screen-down)
  (global-set-key [remap scroll-up-command] 'golden-ratio-scroll-screen-up))

(use-package haskell-mode
  :ensure t
  :config
  (load "haskell-mode-autoloads")
  :init
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))


(use-package htmlize
  :ensure t)


(use-package ibuffer-vc
  :ensure t
  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

(use-package ido
  :ensure t
  :config
  (ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  (setq ido-auto-merge-work-directories-length -1)
  (setq ido-use-virtual-buffers t)
  (setq ido-everywhere t))


(use-package intero
  :ensure t
  :init
  (add-hook 'haskell-mode-hook 'intero-mode))


(use-package ledger-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode))
  :config
  (setq ledger-post-amount-alignment-column 66)
  (setq-default ledger-post-use-completion-engine :ido)
  (setq ledger-reports
	'(("monthly-expenses" "ledger --monthly --empty --collapse -f %(ledger-file) reg ^expenses")
	  ("details" "ledger -f %(ledger-file) -s --current --no-color --no-total bal")
	  ("overview" "ledger -f %(ledger-file) -s --current --real --no-color bal Assets or Liabilities")
	  ("bal" "ledger -f %(ledger-file) bal")
	  ("reg" "ledger -f %(ledger-file) reg")
	  ("payee" "ledger -f %(ledger-file) reg @%(payee)")
	  ("account" "ledger -f %(ledger-file) reg %(account)"))))


(use-package love-minor-mode
  :ensure t)


(use-package lua-mode
  :ensure t)


(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (let ((github-markdown-css
         (with-temp-buffer
           ;; See https://github.com/sindresorhus/github-markdown-css
           (insert-file-contents "~/.emacs.d/vendor/markdown/github-markdown.css")
           (buffer-string))))
    (setq markdown-command "pandoc")
    (setq markdown-xhtml-header-content
          (concat "<style>" github-markdown-css "</style>"))
    (setq markdown-xhtml-body-preamble "<div class=\"markdown-body\">")
    (setq markdown-xhtml-body-epilogue "</div>")))


(use-package org
  :ensure t
  :bind
  (("C-c c" . org-capture))
  :preface
  (defconst diary-path "~/Documents/diary")
  (defun diary-file (fname)
    "Build an absolute path for an org-file.  FNAME is the file name."
    (format "%s/%s" diary-path fname))
  (setq diary-enabled (file-exists-p diary-path))
  :init
  (add-hook 'org-mode-hook #'turn-on-visual-line-mode)
  (when diary-enabled
    (add-hook 'emacs-startup-hook
              (lambda ()
                (interactive)
                (org-agenda nil "A")))
    (add-hook 'org-mode-hook (lambda ()
                               (auto-revert-mode 1)
                               (require 'ob-clojure)))
    ;; http://orgmode.org/worg/org-hacks.html
    (defadvice org-archive-subtree (before
                                    add-inherited-tags-before-org-archive-subtree
                                    activate)
      "add inherited tags before org-archive-subtree"
      (org-set-tags-to (org-get-tags-at)))
    (setq org-log-done 'time
          org-ellipsis " ▼"
          org-enforce-todo-dependencies t
          org-enforce-todo-checkbox-dependencies t
          org-archive-location "archived.org::datetree/* Finished Tasks"
          org-agenda-files `(,(diary-file "calendar.org")
                             ,(diary-file "gtd.org")
                             ,(diary-file "journal.org"))
          org-refile-targets `((org-agenda-files . (:maxlevel . 3))
                               (,(diary-file "someday.org") . (:maxlevel . 3))))
    (setq-default org-capture-templates `(("t"
                                           "Todo"
                                           entry
                                           (file+headline ,(diary-file "gtd.org") "Tasks")
                                           (file ,(diary-file "templates/todo.txt")))
                                          ("j"
                                           "Journal entry"
                                           entry
                                           (file+datetree ,(diary-file "journal.org"))
                                           (file ,(diary-file "templates/journal.txt")))
                                          ("s"
                                           "Someday"
                                           entry
                                           (file+olp ,(diary-file "someday.org") "Backlog" "Other")
                                           (file ,(diary-file "templates/someday.txt")))
                                          ("d"
                                           "Daily review"
                                           entry
                                           (file+datetree ,(diary-file "journal.org"))
                                           (file ,(diary-file "templates/daily_review.txt")))
                                          ("w"
                                           "Weekly review"
                                           entry
                                           (file+datetree ,(diary-file "journal.org"))
                                           (file ,(diary-file "templates/weekly_review.txt"))))
                  org-agenda-window-setup 'current-window
                  org-agenda-dim-blocked-tasks t
                  org-agenda-skip-deadline-if-done t
                  org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled
                  org-agenda-custom-commands '(("A" "Customised agenda"
                                                ((agenda "" ((org-agenda-span 1)))
                                                 (todo "ACTIVE")
                                                 (todo "TODO"))))
                  org-stuck-projects '("LEVEL=2&CATEGORY=\"Projects\"" ("TODO" "ACTIVE") nil "")
                  org-src-fontify-natively t
                  org-html-htmlize-output-type 'css))
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((clojure . t)
                                 (emacs-lisp . t)
                                 (shell . t))))


;; org-reveal doesn't install properly from MELPA for now.
;; see: https://github.com/yjwen/org-reveal/issues/342
(require 'ox-reveal)
(setq org-reveal-root (concat (file-name-directory (or load-file-name
                                                       buffer-file-name))
                              "vendor/reveal.js-master-33bed47/"))


(use-package paredit
  :ensure t
  :init
  (autoload 'enable-paredit-mode "paredit"
    "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook        #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook              #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook              #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook  #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook            #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook        #'paredit-mode))


(use-package plantuml-mode
  :ensure t
  :init
  (setq plantuml-jar-path "~/bin/plantuml.jar"))


(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


(use-package rust-mode
  :ensure t
  :init
  (add-hook 'rust-mode-hook #'flycheck-rust-setup)
  :config
  (setq rust-format-on-save t))


(use-package seq
  :ensure t)


(use-package smex
  :ensure t
  :bind
  (("M-x" . smex)
   ;; ("M-x" . smex-major-mode-commands)
   ;; Vanilla M-x
   ("C-c C-c C-c" . execute-extended-command))
  :init
  (smex-initialize))


(use-package tomatinho
  :ensure t
  :bind
  (("<f12>" . tomatinho)))


(use-package yaml-mode
  :ensure t)


(provide 'init)
;;; init.el ends here
