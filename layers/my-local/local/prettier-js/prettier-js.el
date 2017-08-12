;;; prettier-js.el --- Minor mode to format JS code on file save

;;; Commentary:
;; Formats your JavaScript code using 'prettier' on file save.
;; Requires 'prettier' npm global package

;;; Code:

(defgroup prettier-js nil
  "Minor mode to format JS code on file save"
  :group 'languages
  :prefix "prettier-js"
  :link '(url-link :tag "Repository" "https://github.com/prettier/prettier"))

(defcustom prettier-js-command "prettier"
  "The 'prettier' command."
  :type 'string
  :group 'prettier-js)

(defcustom prettier-js-args '()
  "List of args to send to prettier command."
  :type '(repeat string)
  :group 'prettier-js)

(defcustom prettier-js-show-errors 'buffer
  "Where to display prettier error output.
It can either be displayed in its own buffer, in the echo area, or not at all.
Please note that Emacs outputs to the echo area when writing
files and will overwrite prettier's echo output if used from inside
a `before-save-hook'."
  :type '(choice
          (const :tag "Own buffer" buffer)
          (const :tag "Echo area" echo)
          (const :tag "None" nil))
  :group 'prettier-js)

(defcustom prettier-js-width-mode nil
  "Specify width when formatting buffer contents."
  :type '(choice
          (const :tag "Window width" window)
          (const :tag "Fill column" fill)
          (const :tag "None" nil))
  :group 'prettier-js)

(defun prettier-js--goto-line (line)
  "Move cursor to line LINE."
  (goto-char (point-min))
  (forward-line (1- line)))

(defun prettier-js--apply-rcs-patch (patch-buffer)
  "Apply an RCS-formatted diff from PATCH-BUFFER to the current buffer."
  (let ((target-buffer (current-buffer))
        ;; Relative offset between buffer line numbers and line numbers
        ;; in patch.
        ;;
        ;; Line numbers in the patch are based on the source file, so
        ;; we have to keep an offset when making changes to the
        ;; buffer.
        ;;
        ;; Appending lines decrements the offset (possibly making it
        ;; negative), deleting lines increments it. This order
        ;; simplifies the forward-line invocations.
        (line-offset 0))
    (save-excursion
      (with-current-buffer patch-buffer
        (goto-char (point-min))
        (while (not (eobp))
          (unless (looking-at "^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)")
            (error "Invalid rcs patch or internal error in prettier-js--apply-rcs-patch"))
          (forward-line)
          (let ((action (match-string 1))
                (from (string-to-number (match-string 2)))
                (len  (string-to-number (match-string 3))))
            (cond
             ((equal action "a")
              (let ((start (point)))
                (forward-line len)
                (let ((text (buffer-substring start (point))))
                  (with-current-buffer target-buffer
                    (setq line-offset (- line-offset len))
                    (goto-char (point-min))
                    (forward-line (- from len line-offset))
                    (insert text)))))
             ((equal action "d")
              (with-current-buffer target-buffer
                (prettier-js--goto-line (- from line-offset))
                (setq line-offset (+ line-offset len))
                (kill-whole-line len)
                (setq kill-ring (cdr kill-ring))))
             (t
              (error "Invalid rcs patch or internal error in prettier-js--apply-rcs-patch")))))))))

(defun prettier-js--process-errors (filename tmpfile errorfile errbuf)
  "Process errors for FILENAME, using a TMPFILE an ERRORFILE and display the output in ERRBUF."
  (with-current-buffer errbuf
    (if (eq prettier-js-show-errors 'echo)
        (progn
          (message "%s" (buffer-string))
          (prettier-js--kill-error-buffer errbuf))
      (insert-file-contents errorfile nil nil nil)
      ;; Convert the prettier stderr to something understood by the compilation mode.
      (goto-char (point-min))
      (insert "prettier errors:\n")
      (while (search-forward-regexp (regexp-quote tmpfile) nil t)
        (replace-match (file-name-nondirectory filename)))
      (compilation-mode)
      (display-buffer errbuf))))

(defun prettier-js--kill-error-buffer (errbuf)
  "Kill buffer ERRBUF."
  (let ((win (get-buffer-window errbuf)))
    (if win
        (quit-window t win)
      (with-current-buffer errbuf
        (erase-buffer))
      (kill-buffer errbuf))))

(defun prettier-js ()
  "Format the current buffer according to the prettier tool."
  (interactive)
  (let ((encoding (if (string-equal system-type "windows-nt") 'dos 'utf-8)))
    (let* ((ext (file-name-extension buffer-file-name t))
           (bufferfile (make-temp-file "prettier" nil ext))
           (outputfile (make-temp-file "prettier" nil ext))
           (errorfile (make-temp-file "prettier" nil ext))
           (errbuf (if prettier-js-show-errors (get-buffer-create "*prettier errors*")))
           (patchbuf (get-buffer-create "*prettier patch*"))
           (coding-system-for-read encoding)
           (coding-system-for-write encoding)
           (width-args
            (cond
             ((equal prettier-js-width-mode 'window)
              (list "--print-width" (number-to-string (window-body-width))))
             ((equal prettier-js-width-mode 'fill)
              (list "--print-width" (number-to-string fill-column)))
             (t
              '()))))
      (unwind-protect
          (save-restriction
            (widen)
            (write-region nil nil bufferfile)
            (if errbuf
                (with-current-buffer errbuf
                  (setq buffer-read-only nil)
                  (erase-buffer)))
            (with-current-buffer patchbuf
              (erase-buffer))
            (if (zerop (apply 'call-process
                              prettier-js-command bufferfile (list (list :file outputfile) errorfile)
                              nil (append prettier-js-args width-args (list "--stdin" "--stdin-filepath" buffer-file-name))))
                (progn
                  (call-process-region (point-min) (point-max) "diff" nil patchbuf nil "-n" "-"
                                       outputfile)
                  (prettier-js--apply-rcs-patch patchbuf)
                  (message "Applied prettier with args `%s'" prettier-js-args)
                  (if errbuf (prettier-js--kill-error-buffer errbuf)))
              (message "Could not apply prettier")
              (if errbuf
                  (prettier-js--process-errors (buffer-file-name) bufferfile errorfile errbuf))
              ))
        (kill-buffer patchbuf)
        (delete-file errorfile)
        (delete-file bufferfile)
        (delete-file outputfile)))))

;;;###autoload
(define-minor-mode prettier-js-mode
  "Runs prettier on file save when this mode is turned on"
  :lighter " prettier"
  :global nil
  (if prettier-js-mode
      (add-hook 'before-save-hook 'prettier-js nil 'local)
    (remove-hook 'before-save-hook 'prettier-js 'local)))

(provide 'prettier-js)
;;; prettier-js.el ends here
