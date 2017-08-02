                                        ; -*- mode: emacs-lisp -*-

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     ;; pandoc
     (org
      :variables
      org-link-frame-setup (quote ((vm . vm-visit-folder-other-frame)
                                   (vm-imap . vm-visit-imap-folder-other-frame)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file)
                                   (wl . wl-other-frame))))
     shell
     spotify
     (auto-completion
      :variables
      auto-completion-enable-snippets-in-popup t
      auto-completion-return-key-behavior nil
      auto-completion-enable-help-tooltip 'manual
      auto-completion-tab-key-behavior 'complete)
     docker
     vimscript
     html
     elm
     nginx
     elixir
     (typescript :variables
                 typescript-fmt-on-save nil)
     python
     javascript
     yaml
     evil-commentary
     evil-snipe
     helm
     better-defaults
     emacs-lisp
     git
     markdown
     syntax-checking
     version-control)
   dotspacemacs-additional-packages
   '(
     google-this
     nlinum-relative
     all-the-icons)
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages
   '(
     vi-tilde-fringe)
   dotspacemacs-install-packages 'used-only))
(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists nil
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(atom-one-dark spacemacs-dark majapahit-dark)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font
   '(("Consolas" :size 15 :weight normal :width normal :powerline-scale 1.0)
     ("Source Code Pro" :size 15 :weight normal :width normal :powerline-scale 1.0)
     ("Courier New" :size 15 :weight normal :width normal :powerline-scale 1.0)
     ("monospace" :size 15 :weight normal :width normal :powerline-scale 1.0))
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text t
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header t
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-fullscreen-at-startup t
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title nil
   dotspacemacs-show-transient-state-color-guide nil
   dotspacemacs-mode-line-unicode-symbols nil
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers nil
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup nil
   ))
(defun dotspacemacs/user-init ()
  (setq-default
   dotspacemacs-remap-Y-to-y$ t
   evil-shift-round nil)

  ;; Local packages.
  (load "~/.spacemacs.d/local/prettier-js.el")

  ;; No ugliness at the bottom of this file.
  (setq custom-file "~/.spacemacs.d/.emacs_custom.el")
  (load custom-file 'noerror)
  )
(defun dotspacemacs/user-config ()
  ;; Files and directories which will be ignored in projectile and will be hidden in neotree.
  (setq ignored-files '("package-lock\.json")
        ignored-directories '("node_modules"))

  (load "~/.spacemacs.d/config/buffers.el")
  (load "~/.spacemacs.d/config/evil.el")
  (load "~/.spacemacs.d/config/extra-global-bindings.el")
  (load "~/.spacemacs.d/config/eye-browse.el")
  (load "~/.spacemacs.d/config/helm.el")
  (load "~/.spacemacs.d/config/neotree.el")
  (load "~/.spacemacs.d/config/org.el")
  (load "~/.spacemacs.d/config/proced.el")
  (load "~/.spacemacs.d/config/projectile.el")
  (load "~/.spacemacs.d/config/scroll.el")
  (load "~/.spacemacs.d/config/shell.el")
  (load "~/.spacemacs.d/config/syntax.el")

  (setq
   garbage-collection-messages t
   gc-cons-threshold 112000000
   powerline-default-separator 'bar
   inhibit-compacting-font-caches t
   create-lockfiles nil)
  (mouse-avoidance-mode 'banish))
