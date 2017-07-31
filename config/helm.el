(with-eval-after-load 'helm

  (helm-adaptive-mode)

  ;; Set height of all helm windows.
  (setq helm-autoresize-max-height 30
        helm-autoresize-min-height 30)
  (helm-autoresize-mode 1))
