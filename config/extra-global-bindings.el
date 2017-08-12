(define-key evil-normal-state-map (kbd "C-=") #'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C--") #'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "C-3") #'zoom-frm-in)
(define-key evil-normal-state-map (kbd "C-4") #'zoom-frm-out)
(define-key evil-normal-state-map (kbd "SPC s l") #'helm-semantic-or-imenu)
(define-key global-map (kbd "C-a") #'mark-whole-buffer)
(define-key evil-normal-state-local-map (kbd "SPC b M") #'spacemacs/kill-other-buffers)
(defun open-messages-buffer nil (interactive) (display-buffer (messages-buffer)))
(define-key evil-normal-state-local-map (kbd "SPC b m") #'open-messages-buffer)
(move-text-default-bindings)

(define-key evil-normal-state-local-map (kbd "SPC w v") #'split-window-right-and-focus)
(define-key evil-normal-state-local-map (kbd "SPC w V") #'split-window-right)
(define-key evil-normal-state-map (kbd "RET") (kbd "i RET <escape>"))
(define-key evil-normal-state-map (kbd "M-<right>") #'next-buffer)
(define-key evil-normal-state-map (kbd "M-<left>") #'previous-buffer)
(define-key evil-normal-state-local-map (kbd "SPC r j") #'jump-to-register)
(define-key evil-normal-state-local-map (kbd "SPC a g") #'google-this)
(define-key global-map (kbd "ESC ESC") nil)
(define-key evil-normal-state-local-map (kbd "SPC a o h") #'helm-org-agenda-files-headings)
(define-key evil-normal-state-local-map (kbd "SPC o") #'helm-org-agenda-files-headings)
