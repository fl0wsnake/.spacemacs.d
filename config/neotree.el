(with-eval-after-load 'neotree
  (setq
   neo-mode-line-type 'none
   neo-modern-sidebar nil
   neo-create-file-auto-open nil
   neo-show-hidden-files nil
   neo-theme 'icons
   neo-banner-message nil)

  ;; Switch back to neotree
  (advice-add 'neotree-enter :after (lambda (&rest rest)
                                      "Switch back to neotree."
                                      (winum-select-window-0)))

  ;; '1-9' inside neotree open file in corresponding window (if it exists)
  (mapcar
   (lambda (num)
     (let ((fun (intern (format "winum-select-window-%d" num)))
           (key (kbd (format "%d" num))))
       (evil-define-key
         'evilified
         neotree-mode-map key
         (lexical-let ((num num)(key key)(fun fun))
           (lambda nil
             (interactive)
             (if (and
                  (not (winum-get-window-by-number num))
                  (winum-get-window-by-number (- num 1)))
                 (progn
                   (neotree-enter-vertical-split)
                   (winum-select-window-0))
               (progn
                 (funcall fun)
                 (winum-select-window-0)
                 (neotree-enter)))
             )))))
   (number-sequence 1 9))

  ;; Hide neotree on switch
  (cl-flet
      ((hide-neotree-after
        (f)
        (lexical-let ((f f))
          (lambda nil
            (interactive)
            (funcall f)
            (neotree-hide)))))
    (mapcar
     (lambda (n)
       (define-key
         evil-normal-state-map
         (kbd (format "SPC %d" n))
         (hide-neotree-after
          (intern (format "winum-select-window-%d" n)))))
     (number-sequence 1 9)))

  (let ((ignore-regex-list
         (mapcar (lambda (x) (format "^%s$" x))
                 (append ignored-files ignored-directories))))
    (setq neo-hidden-regexp-list
          (append neo-hidden-regexp-list ignore-regex-list))))
