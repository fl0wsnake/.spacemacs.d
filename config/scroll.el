(add-hook 'prog-mode-hook 'nlinum-relative-mode)

(setq nlinum-relative-redisplay-delay 0.04
      scroll-margin 1)

(define-key evil-normal-state-map (kbd "C-e") (lambda nil (interactive) (evil-scroll-line-down 2)))
(define-key evil-normal-state-map (kbd "C-y") (lambda nil (interactive) (evil-scroll-line-up 2)))
