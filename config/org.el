(require 'org)
(require 'helm-org)
(defun helm-org-in-buffer-headings ()
  (interactive)
  (helm :sources (helm-source-org-headings-for-files (list (buffer-file-name)))
        :candidate-number-limit 99999
        :truncate-lines helm-org-truncate-lines
        :buffer "*helm org inbuffer*"))

(define-key evil-normal-state-local-map (kbd "SPC o b") #'helm-org-in-buffer-headings)
(define-key org-mode-map (kbd "C-M-S-<return>") #'org-insert-todo-subheading)
(define-key org-mode-map (kbd "C-a") #'org-archive-subtree)
(define-key org-mode-map (kbd "C-M-<return>") #'org-insert-subheading)

;; Remove warning
(defalias #'org-projectile:per-repo #'org-projectile-per-project)

;; Clock persistence
(org-clock-persistence-insinuate)

(setq
 org-startup-folded t
 org-adapt-indentation nil
 org-cycle-emulate-tab nil
 org-bullets-bullet-list '("♠" "♣" "♥" "♦" "♤" "♧" "♡" "♢")
 org-M-RET-may-split-line nil
 org-log-done 'time
 helm-org-show-filename t
 org-agend-window-setup 'current-window
 org-agenda-files (list
                   (expand-file-name "todos.org" org-directory)
                   (expand-file-name "notes.org" org-directory)
                   )
 org-todo-keywords
 (quote (
         (sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "HOLD(h@/!)" "|" "DONE(d)" "CANCELLED(c)")))
 ;; org-todo-state-tags-triggers
 ;; (quote (("CANCELLED" ("CANCELLED" . t))
 ;;         ("WAITING" ("WAITING" . t))
 ;;         ("HOLD" ("WAITING") ("HOLD" . t))
 ;;         (done ("WAITING") ("HOLD"))
 ;;         ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
 ;;         ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
 ;;         ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))
 org-todo-keyword-faces
 (quote (
         ;; ("TODO" :foreground "#cdc673" :weight bold)
         ;; ("NEXT" :foreground "#ffc008" :weight bold)
         ;; ("DONE" :foreground "#ff8247" :weight bold)
         ;; ("CANCELLED" :foreground "#cd6839" :weight bold)
         ;; ("WAITING" :foreground "#ff6a6a" :weight bold)
         ;; ("HOLD" :foreground "#ff82ab" :weight bold)
         ))
 org-capture-templates
 '(
   ("a" "Project tasks" entry (file+headline "todos.org" "project")
    "* TODO %?\n" :prepend t)
   ("t" "Todos" entry (file+headline "todos.org" "overall")
    "* TODO %?\n" :prepend t)
   ("j" "Journal" entry (file+datetree "journal.org")
    "* %U\n  %?")))

(set-face-foreground 'org-level-1 "#9f54ff")
(set-face-foreground 'org-level-2 "#28a3ff")
(set-face-foreground 'org-level-3 "#00d9d0")
(set-face-foreground 'org-level-4 "#2bb52b")
(set-face-foreground 'org-level-5 "#ff771e")
(set-face-foreground 'org-level-6 "#db2828")
(set-face-foreground 'org-level-7 "#e03997")
(set-face-foreground 'org-level-8 "#b93ae4")

;; Show first level children of node after going to it
(let ((show-children
       (lambda (&rest r)
         "org-show-children"
         (org-show-children))))
  (advice-add 'helm-org-agenda-files-headings :after show-children)
  (advice-add 'helm-org-in-buffer-headings :after show-children))

;; Always open buffers in same window
(defun org-switch-to-buffer-other-window (buffer-or-name &optional norecord force-same-window)
  (switch-to-buffer buffer-or-name norecord force-same-window))
(defalias 'switch-to-buffer-other-window #'org-switch-to-buffer-other-window)

;; M-RET always inserts heading before
(advice-add 'org-insert-heading :around
            (lambda (orig-fun &optional ARG INVISIBLE-OK TOP)
              (org-end-of-line)
              (funcall orig-fun ARG INVISIBLE-OK TOP)))

;; Show children before inserting a new one
(advice-add 'org-insert-subheading :before
            (lambda (&rest r)
              (org-show-children)))
(advice-add 'org-insert-todo-subheading :before
            (lambda (&rest r)
              (org-show-children)))

;; Word-wrap
(add-hook 'org-mode-hook #'(lambda ()
                             (visual-line-mode)))
