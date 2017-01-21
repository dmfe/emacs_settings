(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; enable neotree
(global-set-key [f8] 'neotree-toggle)

;; enable auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20161029.643/dict")
(ac-config-default)

;; Stop Emacs from losing undo information by
;; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; Determine the underlying operating system
(setq my-aquamacs (featurep 'aquamacs))
(setq my-linux (featurep 'x))
(setq my-win32 (not (or my-aquamacs my-linux)))

(global-hl-line-mode 1)
(set-face-background 'hl-line "midnight blue")

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)
(setq my-font "outline-DejaVu Sans Mono")

(tool-bar-mode 0)

; Turn off the bell
(defun nil-bel ())
(setq ring-bell-function 'nil-bel)

; no screwing with my middle mouse button
(global-unset-key [mouse-2])

(load-library "view")
(require 'ido)
(ido-mode t)

; Setup find files
(define-key global-map "\ef" 'find-file)
(define-key global-map "\eF" 'find-file-other-window)

(global-set-key (read-kbd-macro "\eb") 'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB") 'ido-switch-buffer-other-window)

(define-key global-map "\ew" 'other-window)

; Buffers
(define-key global-map "\er" 'revert-buffer)
(define-key global-map "\ek" 'kill-this-buffer)

; Editting
(define-key global-map "" 'copy-region-as-kill)
(define-key global-map "" 'yank)
(define-key global-map "" 'nil)
(define-key global-map "" 'rotate-yank-pointer)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e^" 'captilize-word)
(define-key global-map "\e." 'fill-paragraph)
(define-key global-map "\e " (lambda () (interactive) (push-mark)))
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)
(delete-selection-mode 1)

; Window
(global-set-key (kbd "C-c s") 'shrink-window)
(global-set-key (kbd "C-c e") 'enlarge-window)

;Search
(global-set-key (kbd "C-c o") 'occur)

;Modes
(global-set-key (kbd "C-c w") 'whitespace-mode)

; Smooth scroll
(setq scroll-step 3)

; Clock
(display-time)

; Set default directory
(setq default-directory "~")

; Set scratch as default buffer and don't open logo buffer
(setq inhibit-startup-screen t)

; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
;(split-window-horizontally)

(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))
(set-face-attribute 'default t :font "DejaVu Sans Mono-12")
(set-face-attribute 'font-lock-builtin-face nil :foreground "#DAB98F")
(set-face-attribute 'font-lock-comment-face nil :foreground "gray50")
(set-face-attribute 'font-lock-constant-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-doc-face nil :foreground "gray50")
(set-face-attribute 'font-lock-function-name-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-keyword-face nil :foreground "DarkGoldenrod3")
(set-face-attribute 'font-lock-string-face nil :foreground "olive drab")
(set-face-attribute 'font-lock-type-face nil :foreground "burlywood3")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "burlywood3")

(defun post-load-stuff ()
  (interactive)
  (menu-bar-mode -1)
;  (maximize-frame)
  (set-foreground-color "burlywood3")
  (set-background-color "#161616")
  (set-cursor-color "#40FF40")
)
(add-hook 'window-setup-hook 'post-load-stuff t)

(setq column-number-mode t)

; Will not allow to add new line to the end of the buffer when save file.
(setq mode-require-final-newline nil)
(setq require-final-newline nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(delete-auto-save-files nil)
 '(delete-old-versions (quote other))
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(make-backup-file-name-function (quote ignore))
 '(make-backup-files nil)
 '(mouse-wheel-follow-mouse nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (15)))
 '(version-control nil))

;Working with directories.
(setq currentBranch nil)

(defun my-save-buffer ()
  "Save the buffer after untabifying it."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (delete-trailing-whitespace)
      (untabify (point-min) (point-max))))
  (save-buffer))

(define-key global-map "\es" 'my-save-buffer)

; Compilation
(require 'compile)

(setq my-makescript "./build.sh")

(defun my-big-fun-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
)

(add-hook 'compilation-mode-hook 'my-big-fun-compilation-hook)

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p my-makescript) t
      (cd "../")
      (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
  (cd find-project-from-directory)
  (find-project-directory-recursive)
  (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile my-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)

(defun eshell-clear-buffer ()
  "Clear terminal"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(add-hook 'eshell-mode-hook
          '(lambda() (local-set-key (kbd "C-l")
                                    'eshell-clear-buffer)))