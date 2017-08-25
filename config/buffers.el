;; Register mappings for jump-to-register function
(set-register ?o (cons 'file org-directory))

;; Not create split window for some buffers
(add-to-list
 'display-buffer-alist
 '((lambda (buffer-name display-fun) (not (cl-search "*NeoTree*" buffer-name))) display-buffer-same-window)
 )

;; No prompt to kill processes on exit
(advice-add 'save-buffers-kill-emacs :around
            (lambda (orig-fun &optional arg)
              "Prevent annoying \"Active processes exist\" query when you quit Emacs."
              (cl-letf (((symbol-function #'process-list) (lambda ()))) (funcall orig-fun arg))))

;; Killing buffer's doesn't ask to kill precesses
(setq kill-buffer-query-functions
      (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Save all buffers on focus out
(add-hook 'focus-out-hook (lambda nil (save-some-buffers t)))

;; Collect garbage on focus out
(add-hook 'focus-out-hook #'garbage-collect)

;; 'gf' doesn't prompt
(advice-add 'find-file-at-point :around
            (lambda (orig-fun &rest filename)
              "No prompt if file exists (or if it doesn't actually)."
              (let ((path (or filename (ffap-guesser))))
                (if (file-readable-p path)
                    (find-file-existing path)
                  (funcall orig-fun path)))))

;; Magit open file in other window
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode)))
                    nil
                  '(display-buffer-same-window)))))

(defun my-switch-to-buffer-this-window (buffer-or-name &optional norecord force-same-window)
  (switch-to-buffer buffer-or-name norecord t))
(defalias 'switch-to-buffer-other-window 'my-switch-to-buffer-this-window)

(defun tide-documentation-at-point ()
  "Show documentation of the symbol at point."
  (interactive)
  (tide-command:quickinfo
   (tide-on-response-success-callback response nil
     (-if-let (buffer (tide-construct-documentation (plist-get response :body)))
         (switch-to-buffer buffer)
       (message "No documentation available.")))))
