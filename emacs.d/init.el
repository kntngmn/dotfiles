(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;; <leaf-inititialize>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "http://orgmode.org/elpa/")
                       ("melpa" . "http://melpa.org/packages/")
                       ("gnu"   . "http://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))
;; </leaf-initialize>

(leaf flycheck
  :disabled t
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "tools" "languages" "convenience" "emacs>=24.3"
  :added "2021-07-29"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :config
  (global-flycheck-mode))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :req "emacs-26.1" "leaf-3.6.0" "leaf-keywords-1.1.0" "ppp-2.1"
  :tag "tools" "emacs>=26.1"
  :added "2021-07-25"
  :url "https://github.com/conao3/leaf-convert.el"
  :emacs>= 26.1
  :ensure t)

(leaf leaf-tree
  :doc "Interactive side-bar feature for init.el using leaf"
  :req "emacs-25.1" "imenu-list-0.8"
  :tag "leaf" "convenience" "emacs>=25.1"
  :added "2021-07-25"
  :url "https://github.com/conao3/leaf-tree.el"
  :emacs>= 25.1
  :ensure t
  :custom ((imenu-list-size     . 30)
           (imenu-list-position . 'left)))

(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :req "emacs-27.1"
  :tag "emacs>=27.1"
  :added "2021-07-25"
  :url "https://github.com/minad/vertico"
  :emacs>= 27.1
  :ensure t
  :init
  (vertico-mode)
  :custom ((vertico-count . 20)))

(leaf consult
  :doc "Consulting completing-read"
  :req "emacs-26.1"
  :tag "emacs>=26.1"
  :added "2021-07-25"
  :url "https://github.com/minad/consult"
  :emacs>= 26.1
  :ensure t
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ("C-x C-g" . consult-goto-line)
         ("C-x C-o" . consult-outline)))

(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :req "emacs-26.1"
  :tag "extensions" "emacs>=26.1"
  :added "2021-07-25"
  :url "https://github.com/oantolin/orderless"
  :emacs>= 26.1
  :ensure t
  :custom ((completion-styles . '(orderless))))

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :req "emacs-26.1"
  :added "2021-07-25"
  :url "https://github.com/minad/marginalia"
  :emacs>= 26.1
  :ensure t
  :init
  (marginalia-mode)
  (savehist-mode))

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-25.1"
  :added "2021-07-31"
  :url "http://company-mode.github.io/"
  :emacs>= 25.1
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("C-f" . company-abort)
          ("C-g" . company-abort))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("C-f" . company-abort)
          ("C-g" . company-abort)))
  :custom ((company-tooltip-limit         . 12)
           (company-idle-delay            . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers          . '(company-sort-by-occurrence))
           (company-selection-wrap-around .	t)
           (completion-ignore-case        . t))
  :global-minor-mode global-company-mode)

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1" "cl-lib-0.6"
  :tag "environment" "unix" "emacs>=24.1"
  :added "2021-07-26"
  :url "https://github.com/purcell/exec-path-from-shell"
  :emacs>= 24.1
  :ensure t
  :custom ((exec-path-from-shell-variables. '("SHELL" "PATH"))))

(leaf dracula-theme
  :doc "Dracula Theme"
  :req "emacs-24.3"
  :tag "emacs>=24.3"
  :added "2021-07-25"
  :url "https://github.com/dracula/emacs"
  :emacs>= 24.3
  :ensure t
  :config
  (load-theme 'dracula t))

(leaf doom-modeline
  :doc "A minimal and modern mode-line"
  :req "emacs-25.1" "all-the-icons-2.2.0" "shrink-path-0.2.0" "dash-2.11.0"
  :tag "mode-line" "faces" "emacs>=25.1"
  :added "2021-07-26"
  :url "https://github.com/seagle0128/doom-modeline"
  :emacs>= 25.1
  :ensure t
  :custom ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
           (doom-modeline-icon                   . (display-graphic-p))
           (doom-modeline-major-mode-icon        . nil)
           (doom-modeline-major-mode-color-icon  . t)
           (doom-modeline-minor-modes            . t)
           (doom-modeline-buffer-file-state-icon . nil))
  :hook
  (after-init-hook . doom-modeline-mode)
  :config
  (line-number-mode nil)
  (column-number-mode nil)
  (doom-modeline-def-modeline
    'main
    '(bar window-number matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)))

(leaf *git
  :config
  (leaf magit
    :doc "A Git porcelain inside Emacs."
    :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
    :tag "vc" "tools" "git" "emacs>=25.1"
    :added "2021-07-26"
    :url "https://github.com/magit/magit"
    :emacs>= 25.1
    :ensure t
    :bind (("C-x g" . magit-status))))
  
(leaf *functions
  :config
  (leaf other-window-or-split
    :doc "Switch other window. if not split the window horizontally"
    :preface (defun my:other-window-or-split ()
           (interactive)
           (when (one-window-p) (split-window-horizontally))
           (other-window 1))
    :bind (("C-t" . my:other-window-or-split))))

(leaf-keys (("C-h"       . delete-backward-char)
            ("C-z"       . undo)
            ("C-c a"     . align)
            ("C-c C-c"   . comment-region)
            ("C-c C-c"   . uncomment-region)
            ("C-\\"      . ignore)
            ("<M-kanji>" . ignore)
            ("<kanji>"   . ignore)
            ("M-0"       . delete-window)
            ("M-2"       . split-window-vertically)
            ("M-3"       . split-window-horizontally)))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :added "2021-07-28"
  :custom (;; Appearance
           (tool-bar-mode                           . nil)
           (scroll-bar-mode                         . nil)
           (menu-bar-mode                           . nil)
           ;; Indent
           (default-tab-width                       . 4)
           (tab-width                               . 4)
           (indent-tabs-mode                        . nil)
           (indent-tab-width                        . nil)
           ;; Buffer
           (next-line-add-newlines                  . nil)
           (truncate-lines                          . t)
           (scroll-conservatively                   . 1)
           ;; Case (in)sensitive
           (completion-ignore-case                  . t)
           (case-fold-search                        . t)
           (read-file-buffer-completion-ignore-case . t)
           (read-file-name-completion-ignore-case   . t) 
           ;; Backup files
           (make-backup-files                       . nil)
           (auto-save-default                       . nil)
           ;; Others
           (ring-bell-function                      . nil)
           (vc-follow-symlinks                      . t)
           (global-eldoc-mode                       . nil))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :added "2021-08-01"
  :custom ((inhibit-startup-screen				.	t)
           (inhibit-startup-message				.	t)
           (inhibit-startup-echo-area-message	.	t)
           (initial-scratch-message				.	nil)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :added "2021-07-26"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(provide 'init)
