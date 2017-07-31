(defun multishell ()
  (interactive)
  (cl-loop for i from 2 do
           (let ((shname (format "*shell-%d*" i)))
             (when (not (get-buffer shname))
               (get-buffer-create shname)
               (shell shname)
               (return)))))

(define-key evil-normal-state-map (kbd "SPC a s s") #'multishell)
