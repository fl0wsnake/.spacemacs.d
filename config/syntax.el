;; prettier-js
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-js-mode)
(setq prettier-js-args '("--no-semi" "--tab-width=4"))

;; js2
(setq
 js2-strict-missing-semi-warning nil
 js2-missing-semi-one-line-override t
 js2-strict-trailing-comma-warning nil)

;; flycheck
(setq
 flycheck-display-errors-function #'flycheck-pos-tip-mode
 flycheck-pos-tip-timeout 65535
 flycheck-display-errors-delay 1.0)

;; highlight-parentheses
(setq
 hl-paren-colors '("#c4d8ff"))

;; auto-highlight-symbol.
(custom-set-faces '(ahs-face ((t (:background "#383e49")))))
(custom-set-faces '(ahs-plugin-whole-buffer-face ((t (:background "#383e49")))))
(spacemacs/toggle-automatic-symbol-highlight-on)
(add-hook 'evil-visual-state-entry-hook #'spacemacs/toggle-automatic-symbol-highlight-off)
(add-hook 'evil-visual-state-exit-hook #'spacemacs/toggle-automatic-symbol-highlight-on)

;; Face for show-smartparens-mode.
(custom-set-faces '(sp-show-pair-match-face ((t (:background "#505868")))))
