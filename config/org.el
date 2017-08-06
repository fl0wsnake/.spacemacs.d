(org-clock-persistence-insinuate)

(setq
 org-log-done 'time
 helm-org-show-filename t
 org-agend-window-setup 'current-window
 org-agenda-files (list
                   (expand-file-name "todos.org" org-directory)
                   (expand-file-name "notes.org" org-directory)
                   )
 org-todo-keywords
 (quote (
         (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
         (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c!)")))
 ;; org-todo-state-tags-triggers
 ;; (quote (("CANCELLED" ("CANCELLED" . t))
 ;;         ("WAITING" ("WAITING" . t))
 ;;         ("HOLD" ("WAITING") ("HOLD" . t))
 ;;         (done ("WAITING") ("HOLD"))
 ;;         ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
 ;;         ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
 ;;         ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))
 org-todo-keyword-faces
 (quote (("TODO" :foreground "pink" :weight bold)
         ("NEXT" :foreground "lightblue" :weight bold)
         ("DONE" :foreground "forest green" :weight bold)
         ("WAITING" :foreground "orange" :weight bold)
         ("HOLD" :foreground "magenta" :weight bold)
         ("CANCELLED" :foreground "forest green" :weight bold)
         ("MEETING" :foreground "forest green" :weight bold)
         ("PHONE" :foreground "forest green" :weight bold)))
 org-capture-templates
 '(
   ("a" "Project tasks" entry (file+headline "todos.org" "project")
    "* TODO %?\n" :prepend t)
   ("t" "Todos" entry (file+headline "todos.org" "overall")
    "* TODO %?\n" :prepend t)
   ("j" "Journal" entry (file+datetree "journal.org")
    "* %U\n  %?")))

;; Show first level children of node after going to it.
(advice-add 'helm-org-agenda-files-headings :after
            (lambda (&rest r)
              (org-show-children)))

;; (advice-add 'org-switch-to-buffer-other-window :around
;;             (lambda (orig-fun &rest buffer-or-name norecord)
;;               (switch-to-buffer buffer-or-name norecord t)))

;; always open buffers in same window.
(defun org-switch-to-buffer-other-window (buffer-or-name &optional norecord force-same-window)
  (switch-to-buffer buffer-or-name norecord force-same-window))









;; (org-fast-todo-selection)
;; (org-log-note-headings)
;; (org-todo)


;; (defun my/set-org-log-done (orig-fun &rest)
;;   (let ((c (funcall orig-fun))) (if (= c 68) (progn (setq org-log-done 'note) 100) (progn (setq org-log-done 'time) c))))

;; (advice-add 'org-fast-todo-selection :before '(lambda (&rest)
;;                                                 ;; (advice-add 'read-char-exclusive :around #'my/set-org-log-done)))
;; (advice-add 'org-fast-todo-selection :after (lambda (&rest) (advice-remove 'read-char-exclusive #'my/set-org-log-done)))


;; ;; Macro which creates advice 'template'
;; (defmacro my/with-advice (adlist &rest body)
;;   "Execute BODY with temporary advice in ADLIST.

;; Each element of ADLIST should be a list of the form
;;   (SYMBOL WHERE FUNCTION [PROPS])
;; suitable for passing to `advice-add'.  The BODY is wrapped in an
;; `unwind-protect' form, so the advice will be removed even in the
;; event of an error or nonlocal exit."
;;   (declare (debug ((&rest (&rest form)) body))
;;            (indent 1))
;;   `(progn
;;      ,@(mapcar (lambda (adform)
;;                  (cons 'advice-add adform))
;;                adlist)
;;      (unwind-protect (progn ,@body)
;;        ,@(mapcar (lambda (adform)
;;                    `(advice-remove ,(car adform) ,(nth 2 adform)))
;;                  adlist))))

;; ;; Function which replaces org-switch-to-buffer-other-window with emacs' original switch-to-buffer-other-window
;; (defun hd/org-todo-same-window (orig-fn)
;;   "Advice to fix window placement in `org-fast-todo-selection'."
;;   (let  ((override
;;       '("\\*Org todo\\*|\\*Org Note\\*"
;;         (display-buffer-same-window)
;;         (inhibit-same-window . nil)))) ;locally sets variable "override" as key-value pair for display-buffer-alist entry
;;     (add-to-list 'display-buffer-alist override) ;adds the contents of the above defined variable to display-buffer-alist
;;     (my/with-advice
;;         ((#'org-switch-to-buffer-other-window :override #'switch-to-buffer-other-window))
;;       (unwind-protect (funcall orig-fn)
;;         (setq display-buffer-alist
;;               (delete override display-buffer-alist))))))

;; ;; Injecting the relevant advice into the org-fast-todo-selection function
;; (advice-add #'org-fast-todo-selection :around #'hd/org-todo-same-window)

;; ;; (switch-to-buffer BUFFER-OR-NAME &optional NORECORD FORCE-SAME-WINDOW)
;; (advice-add #'switch-to-buffer :around (lambda (orig-fun BUFFER-OR-NAME &optional NORECORD FORCE-SAME-WINDOW)
;;                                          (funcall orig-fun BUFFER-OR-NAME NORECORD t)))
