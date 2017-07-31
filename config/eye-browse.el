(with-eval-after-load 'eyebrowse
  (mapcar
   (lambda (n)
     (define-key
       evil-normal-state-map
       (kbd (format "g %d" n))
       (intern (format "eyebrowse-switch-to-window-config-%d" n))))
   (number-sequence 1 9)))
