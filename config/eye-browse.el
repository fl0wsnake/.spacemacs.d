(with-eval-after-load 'eyebrowse
  (mapcar
   (lambda (n)
     (let ((fun (intern (format "eyebrowse-switch-to-window-config-%d" n))))
       (define-key
         evil-normal-state-map
         (kbd (format "g %d" n))
         fun)
       (define-key
         eyebrowse-mode-map
         (kbd (format "C-w %d" n))
         fun)))
   (number-sequence 1 9)))
