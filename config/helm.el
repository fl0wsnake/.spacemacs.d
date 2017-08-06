(with-eval-after-load 'helm
  (helm-adaptive-mode 1)

  ;; Set height of all helm windows.
  (setq
   helm-buffers-fuzzy-matching t
   helm-recentf-fuzzy-match t
   ;; helm-move-to-line-cycle-in-source t
   helm-autoresize-max-height 30
   helm-autoresize-min-height 30)
  (helm-autoresize-mode 1))
