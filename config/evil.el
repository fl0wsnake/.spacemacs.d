(setq evil-shift-round nil)

(with-eval-after-load 'evil
  (fset 'evil-visual-update-x-selection 'ignore)
  ;; (defalias #'forward-evil-word #'forward-evil-symbol)

  ;; "w", "e", "b", 'iw', 'aw' - work with symbols;
  ;; "W", "E", "B" - with non-space sequences (default vim behavior);
  ;; "gw", "ge", "gb", "io", "ao" - with sub-words
  ;; (correspond to default behavior of vim"s "w", "e", "b", "iw", "aw");
  (evil-define-motion forward-symbol-begin (count &optional bigword)
    :type exclusive
    (let ((thing 'evil-symbol)
          (orig (point))
          (count (or count 1)))
      (evil-signal-at-bob-or-eob count)
      (cond
       ((not (evil-operator-state-p))
        (evil-forward-beginning thing count))
       ((and evil-want-change-word-to-end
             (eq evil-this-operator #'evil-change)
             (< orig (or (cdr-safe (bounds-of-thing-at-point thing)) orig)))
        (forward-thing thing count))
       (t
        (prog1 (evil-forward-beginning thing count)
          (when (and (> (line-beginning-position) orig)
                     (looking-back "^[[:space:]]*" (line-beginning-position)))
            (evil-move-end-of-line 0)
            (while (and (looking-back "^[[:space:]]+$" (line-beginning-position))
                        (not (<= (line-beginning-position) orig)))
              (evil-move-end-of-line 0))
            (when (bolp) (forward-char))))))))

  (evil-define-motion forward-symbol-end (count &optional bigword)
    :type inclusive
    (let ((thing 'evil-symbol)
          (count (or count 1)))
      (evil-signal-at-bob-or-eob count)
      (unless (and (evil-operator-state-p)
                   (= 1 count)
                   (let ((bnd (bounds-of-thing-at-point thing)))
                     (and bnd
                          (= (car bnd) (point))
                          (= (cdr bnd) (1+ (point)))))
                   (looking-at "[[:word:]]"))
        (evil-forward-end thing count))))

  (evil-define-motion backward-symbol-begin (count &optional bigword)
    :type exclusive
    (let ((thing 'evil-symbol))
      (evil-signal-at-bob-or-eob (- (or count 1)))
      (evil-backward-beginning thing count)))

  (define-key evil-motion-state-map (kbd "w") #'forward-symbol-begin)
  (define-key evil-motion-state-map (kbd "e") #'forward-symbol-end)
  (define-key evil-motion-state-map (kbd "b") #'backward-symbol-begin)
  (define-key evil-inner-text-objects-map (kbd "w") #'evil-inner-symbol)
  (define-key evil-outer-text-objects-map (kbd "w") #'evil-a-symbol)
  (define-key evil-normal-state-map "gw" nil)
  (define-key evil-motion-state-map "gw" 'evil-forward-word-begin)
  (define-key evil-motion-state-map "ge" 'evil-forward-word-end)
  (define-key evil-motion-state-map "gb" 'evil-backward-word-begin)
  (define-key evil-inner-text-objects-map "o" #'evil-inner-word)
  (define-key evil-outer-text-objects-map "o" #'evil-a-word)
  (define-key evil-normal-state-map "gW" #'evil-fill)

  ;; Select last pasted text
  (define-key evil-normal-state-map (kbd "C-s")
    (lambda nil
      (interactive)
      (evil-goto-mark ?[)
                      (evil-visual-char)
                      (evil-goto-mark ?])))

  ;; C-v in insert mode pastes from 1 register
  (defun insert-mode-paste nil (interactive) (evil-paste-from-register ?1))
  (define-key evil-insert-state-map (kbd "C-v") #'insert-mode-paste)

  ;; "p" and "P" don't change registers in visual mode
  (evil-define-command evil-visual-paste (count &optional register)
    (interactive "P<x>")
    (let* ((text (if register
                     (evil-get-register register)
                   (current-kill 0)))
           (yank-handler (car-safe (get-text-property
                                    0 'yank-handler text))))
      (evil-with-undo
        (when (evil-visual-state-p)
          (evil-visual-rotate 'upper-left)
          (evil-delete evil-visual-beginning evil-visual-end
                       (evil-visual-type))
          (unless register
            (kill-new text))
          (when (and (eq yank-handler 'evil-yank-line-handler)
                     (not (eq (evil-visual-type) 'line)))
            (newline))
          (evil-normal-state))
        (if (eobp)
            (evil-paste-after count register)
          (evil-paste-before count register)))))

  (define-key evil-normal-state-map (kbd "SPC d") #'evil-delete)
  (define-key evil-normal-state-map (kbd "SPC D") #'evil-delete-line)
  ;; 'SPC d' == '"_d'
  (evil-define-operator delete-without-yanking (beg end type register yank-handler)
    (evil-delete beg end type ?_ yank-handler))
  (define-key evil-normal-state-map (kbd "d") #'delete-without-yanking)

  ;; 'SPC D' == '"_D'
  (evil-define-operator delete-line-without-yanking (beg end type register yank-handler)
    :motion evil-end-of-line
    (evil-delete-line beg end type ?_ yank-handler))
  (define-key evil-normal-state-map (kbd "D") #'delete-line-without-yanking)

  ;; 'c' doesn't override registers
  (evil-define-operator evil-change (beg end type register yank-handler delete-func)
    (evil-change-original beg end type ?_ yank-handler delete-func))
  (evil-define-operator evil-change-original
    (beg end type register yank-handler delete-func)
    (interactive "<R><x><y>")
    (let ((delete-func (or delete-func 'evil-delete))
          (nlines (1+ (- (line-number-at-pos end)
                         (line-number-at-pos beg))))
          (bop (= beg (buffer-end -1)))
          (eob (= end (buffer-end 1))))
      (funcall delete-func beg end type register yank-handler)
      (cond
       ((eq type 'line)
        (if (and eob (not bop))
            (evil-open-below 1)
          (evil-open-above 1)))
       ((eq type 'block)
        (evil-insert 1 nlines))
       (t
        (evil-insert 1)))))

  ;; 'C' doesn't override registers
  (advice-add 'evil-change-line :around (lambda (orig-fun &optional beg end type register yank-handler)
                                          "Change-line doesn't override registers."
                                          (funcall orig-fun beg end type ?_ yank-handler)))
  )
