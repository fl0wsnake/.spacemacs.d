;;; packages.el --- my-local layer packages file for Spacemacs.

(defconst my-local-packages
  '(
    (prettier-js :location local)))

(defun my-local/init-prettier-js ()
  (use-package prettier-js))

;;; packages.el ends here
