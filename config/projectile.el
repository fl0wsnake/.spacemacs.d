(with-eval-after-load 'projectile
  (setq
   projectile-enable-caching t
   projectile-globally-ignored-directories (append
                                            projectile-globally-ignored-directories
                                            ignored-directories)
   projectile-globally-ignored-files (append
                                      projectile-globally-ignored-files
                                      ignored-files))
  ;; (projectile-maybe-invalidate-cache t)
  )
