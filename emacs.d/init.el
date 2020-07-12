;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
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

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :disabled nil
  :doc "interactive macro expander"
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf custom-theme
  :init (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
  :custom ((custom-theme-directory . "~/.emacs.d/themes"))
  )

(leaf cus-start
  :custom ((tool-bar-mode							.	nil)
           (scroll-bar-mode							.	nil)
           (menu-bar-mode							.	nil)
           (tab-width								.	4)
           (indent-tab-width						.	nil)
           (truncate-lines							.	t)
           (next-line-add-newlines					.	nil)
           (completion-ignore-case					.	t)
           (read-file-name-completion-ignore-case	.	t) 
           (make-backup-files						.	nil)
           (auto-save-default						.	nil)
           (ring-bell-function						.	nil)
           (scroll-conservatively					.	1)
           (vc-follow-symlinks						.	t))
  :config
  (when (boundp 'load-prefer-newer)
    (setq load-prefer-newer t))
  (fset 'yes-or-no-p 'y-or-n-p)
  )

(leaf startup
    :custom ((inhibit-startup-screen			.	t)
             (inhibit-startup-message			.	t)
             (inhibit-startup-echo-area-message	.	t)
             (initial-scratch-message			.	nil)))

(leaf-keys (("C-h"			.	delete-backward-char)
            ("C-z"			.	undo)
            ("C-x C-g"		.	goto-line)
            ("C-c a"		.	align)
            ("C-c C-c"		.	comment-region)
            ("C-c C-c"		.	uncomment-region)
            ("C-\\"			.	ignore)
            ("<M-kanji>"	.	ignore)
            ("<kanji>"		.	ignore)
            ("M-0"			.	delete-window)
            ("M-2"			.	split-window-vertically)
            ("M-3"			.	split-window-horizontally)
            ))

(leaf web-mode
  :disabled t
  :doc "major mode for editing web templates"
  :req "emacs-23.1"
  :tag "languages" "emacs>=23.1"
  :added "2020-07-02"
  :url "http://web-mode.org"
  :emacs>= 23.1
  :ensure t
  :mode "\\.html\\'"
  :custom ((web-mode-enable-auto-pairing . t)
		   (web-mode-enable-auto-closing . t))
  )

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :added "2020-05-03"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t
  :mode "\\.go\\'"
  )


(leaf company-jedi
  :disabled t
  :doc "Company-mode completion back-end for Python JEDI"
  :req "emacs-24" "cl-lib-0.5" "company-0.8.11" "jedi-core-0.2.7"
  :tag "emacs>=24"
  :added "2020-05-27"
  :url "https://github.com/emacsorphanage/company-jedi"
  :emacs>= 24
  :ensure t
  :custom ((complete-on-dot . t))
  )


(leaf elpy
  :disabled nil
  :doc "Emacs Python Development Environment"
  :req "company-0.9.2" "emacs-24.4" "highlight-indentation-0.5.0" "pyvenv-1.3" "yasnippet-0.8.0" "s-1.11.0"
  :tag "emacs>=24.4"
  :added "2020-05-27"
  :emacs>= 24.4
  :ensure t
  :init
  (elpy-enable)
  :config
  (when (require 'set-pyenv-version-path nil t)
   	(add-to-list 'exec-path "~/.anyenv/envs/pyenv/shims"))
  )

(leaf company
  :disabled nil
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-04-29"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :custom ((company-idle-delay				.	0)
           (company-minimum-prefix-length	.	3)
           (company-selection-wrap-around	.	t)
           (completion-ignore-case			.	t))
  :bind ((:company-active-map
          ("C-n"	.	company-select-next)
          ("C-p"	.	company-select-previous)
          ("C-f"	.	company-abort)
          ("C-g"	.	company-abort))
         (:company-search-map
          ("C-n"	.	company-select-next)
          ("C-p"	.	company-select-previous)
          ("C-f"	.	company-abort)
		  ("C-g"	.	company-abort)))
  :hook
  (after-init-hook			.	global-company-mode)
  (after-init-hook			.	company-mode)
  (minibuffer-setup-hook	.	,(lambda () (company-mode -1)))
  :config
  (add-to-list 'company-backends '(company-lsp
								   company-elisp
								   company-jedi))
)

(leaf company-lsp
  :doc "Company completion backend for lsp-mode."
  :req "emacs-25.1" "lsp-mode-6.0" "company-0.9.0" "s-1.2.0" "dash-2.11.0"
  :tag "emacs>=25.1"
  :added "2020-05-06"
  :url "https://github.com/tigersoldier/company-lsp"
  :emacs>= 25.1
  :ensure t
  :after lsp-mode company
  :commands company-lsp company
  :custom ((company-lsp-cache-candidates	.	nil)
		   (company-lsp-async				.	t)
		   (company-lsp-enable-recompletion .	t)
		   (company-lsp-enable-snippet		.	t))
  :after
  (:all lsp-mode company)
)

(leaf auto-complete
  :disabled t
  :doc "Auto Completion for GNU Emacs"
  :req "popup-0.5.0" "cl-lib-0.5"
  :added "2020-04-29"
  :ensure t
  :bind ((:ac-menu-map
          ("C-n" . ac-next)
          ("C-p" . ac-previous)))
  :hook
  `((after-init-hook       . global-auto-complete-mode)
    (minibuffer-setup-hook . ,(lambda () (auto-complete-mode -1))))
)

(leaf git-gutter-fringe+
  :disabled t
  :doc "Fringe version of git-gutter+.el"
  :req "git-gutter+-0.1" "fringe-helper-1.0.1"
  :added "2020-04-29"
  :url "https://github.com/nonsequitur/git-gutter-fringe-plus"
  :ensure t
)

(leaf git-gutter+
  :disabled t
  :doc "Manage Git hunks straight from the buffer"
  :req "git-commit-0" "dash-0"
  :tag "vc" "git"
  :added "2020-04-29"
  :url "https://github.com/nonsequitur/git-gutter-plus"
  :ensure t
  :init (global-git-gutter+-mode)
)

(leaf git-gutter
  :disabled t
  :doc "Port of Sublime Text plugin GitGutter"
  :req "emacs-24.3"
  :tag "emacs>=24.3"
  :added "2020-04-29"
  :url "https://github.com/emacsorphanage/git-gutter"
  :emacs>= 24.3
  :ensure t
  :init (global-git-gutter+-mode)
)

(leaf highlight-indent-guides
  :disabled t
  :doc "Minor mode to highlight indentation"
  :req "emacs-24"
  :tag "emacs>=24"
  :added "2020-04-30"
  :url "https://github.com/DarthFennec/highlight-indent-guides"
  :emacs>= 24
  :ensure t
  :hook ((prog-mode yaml-mode-hook) . highlight-indet-guides-mode)
  :custom ((highlight-indent-guides-auto-enabled . t)
		   (highlight-indent-guides-responsive . t)
		   (highlight-indent-guides-method . 'character)) ; column
)

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :added "2020-05-01"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :init (ivy-mode)
  :custom ((ivy-use-virtual-buffers . t)
		   (enable-recursive-minibuffers . t)
		   (ivy-height . 10)
		   (ivy-extra-directories . nil)
		   (ivy-re-builders-alist . '((t . ivy--regex-plus)))
		   )
  )

(leaf counsel
  :disabled t
  :doc "Various completion functions using Ivy"
  :req "emacs-24.5" "swiper-0.13.0"
  :tag "tools" "matching" "convenience" "emacs>=24.5"
  :added "2020-05-01"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :bind (("M-x" . counsel-M-x)
		 ;;("C-x C-f" . counsel-find-file)
		 )
  :custom ((counsel-find-file-ignore-regexp . (regexp-opt '("./" "../"))))
)

(leaf swiper
  :disabled nil
  :doc "Isearch with an overview. Oh, man!"
  :req "emacs-24.5" "ivy-0.13.0"
  :tag "matching" "emacs>=24.5"
  :added "2020-04-29"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :bind (("C-s" . swiper))
)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-style  . 'mixed))
  :hook (emacs-startup-hook . show-paren-mode))

(leaf hl-line
  :doc "highlight the current line"
  :tag "builtin"
  :hook (emacs-startup-hook . global-hl-line-mode))

(leaf midnight
  :doc "run something every midnight, e.g., kill old buffers"
  :tag "builtin"
  :custom ((clean-buffer-list-delay-general . 1))
  :config
  (midnight-mode))

(leaf other-window-or-split
  :doc "Switch other window. if not split the window horizontally"
  :preface (defun my:other-window-or-split ()
	     (interactive)
	     (when (one-window-p) (split-window-horizontally))
	     (other-window 1))
  :bind (("C-t" . my:other-window-or-split)))

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20180527" "dash-20180910" "git-commit-20181104" "transient-20190812" "with-editor-20181103"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-04-28"
  :emacs>= 25.1
  :ensure t
  :bind (("C-x g" . magit-status))
)

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :added "2020-04-29"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3" "memoize-1.0.1"
  :tag "lisp" "convenient" "emacs>=24.3"
  :added "2020-04-30"
  :url "https://github.com/domtronn/all-the-icons.el"
  :emacs>= 24.3
  :ensure t
)

(leaf custom-theme
  :disabled t
  :config
  (load-theme 'dracula-mod)
)

(leaf monokai-theme
  :disabled t
  :doc "A fruity color theme for Emacs."
  :added "2020-04-29"
  :url "http://github.com/oneKelvinSmith/monokai-emacs"
  :ensure t
  :config
  (load-theme 'monokai t)
)

(leaf monokai-pro-theme
  :disabled t
  :doc "A simple theme based on the Monokai Pro Sublime color schemes"
  :added "2020-05-01"
  :url "https://github.com/belak/emacs-monokai-pro-theme"
  :ensure t
  :config
  (load-theme 'monokai-pro t)
  )

(leaf dracula-theme
  :disabled nil
  :doc "Dracula Theme"
  :req "emacs-24.3"
  :tag "emacs>=24.3"
  :added "2020-05-01"
  :url "https://github.com/dracula/emacs"
  :emacs>= 24.3
  :ensure t
  :config
  (load-theme 'dracula t)
  )

(leaf doom-themes
  :disabled t
  :doc "an opinionated pack of modern color-themes"
  :req "emacs-25.1" "cl-lib-0.5"
  :tag "nova" "faces" "icons" "neotree" "theme" "one" "atom" "blue" "light" "dark" "emacs>=25.1"
  :added "2020-04-30"
  :url "https://github.com/hlissner/emacs-doom-theme"
  :emacs>= 25.1
  :ensure t
  :custom ((doom-themes-enable-bold . t)
		   (doom-themes-enable-italic . t)
		   ;;(doom-dracula-brighter-comments . t)
		   ;;(doom-dracula-comment-bg . nil)
		   )
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
)

(leaf doom-modeline
  :disabled nil
  :doc "A minimal and modern mode-line"
  :req "emacs-25.1" "all-the-icons-2.2.0" "shrink-path-0.2.0" "dash-2.11.0"
  :tag "mode-line" "faces" "emacs>=25.1"
  :added "2020-04-30"
  :url "https://github.com/seagle0128/doom-modeline"
  :emacs>= 25.1
  :ensure t
  :custom ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
   		   (doom-modeline-icon . (display-graphic-p))
   		   (doom-modeline-major-mode-icon . nil)
   		   (doom-modeline-minor-modes . t)
  		   (doom-modeline-buffer-file-state-icon . nil))
  :hook
  (after-init-hook . doom-modeline-mode)
  :config
  (line-number-mode nil)
  (column-number-mode nil)
  (doom-modeline-def-modeline 'main
	'(bar window-number matches buffer-info remote-host buffer-position parrot selection-info)
	'(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker))
  )

(leaf nyan-mode
  :disabled t
  :doc "Nyan Cat shows position in current buffer in mode-line."
  :tag "build something amazing" "pop tart cat" "scrolling" "lulz" "cat" "nyan"
  :added "2020-04-30"
  :url "https://github.com/TeMPOraL/nyan-mode/"
  :ensure t
  :custom ((nyan-cat-face-number . 4)
		   (nyan-animate-nyancat . t)
		   (nyan-bar-length . 8))
  :hook (after-init-hook . nyan-mode)
  )

(leaf sh-mode
  :disabled nil
  :mode "\\zshrc\\'")

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

