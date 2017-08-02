;; Not create split window for some buffers.
(add-to-list
 'display-buffer-alist
 '("^\\*.*\\*$" display-buffer-same-window))

;; No prompt to kill processes on exit.
(advice-add 'save-buffers-kill-emacs :around (lambda (orig-fun &optional arg)
                                               "Prevent annoying \"Active processes exist\" query when you quit Emacs."
                                               (cl-letf (((symbol-function #'process-list) (lambda ()))) (funcall orig-fun arg))))

;; Killing buffer's doesn't ask to kill precesses.
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

;; Save buffers on focus out.
(add-hook 'focus-out-hook (lambda nil (save-some-buffers t)))

;; Collect garbage on focus out.
(add-hook 'focus-out-hook #'garbage-collect)

;; 'gf' doesn't prompt.
(advice-add 'find-file-at-point :around (lambda (orig-fun &rest filename)
                                          "No prompt if file exists (or if it doesn't actually)."
                                          (let ((path (or filename (ffap-guesser))))
                                            (if (file-readable-p path)
                                                (find-file-existing path)
                                              (funcall orig-fun path)))))
