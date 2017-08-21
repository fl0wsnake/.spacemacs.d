(require 'projectile)
(setq
 projectile-enable-caching t
 projectile-globally-ignored-directories (append
                                          ignored-directories
                                          projectile-globally-ignored-directories)
 projectile-globally-ignored-files (append
                                    ignored-files
                                    projectile-globally-ignored-files))
(projectile-global-mode)
