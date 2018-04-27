
(load-theme 'wombat)

;; encoding
(set-locale-environment nil)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; appearance
(setq mode-line-format nil)
(setq-default mode-line-format nil)
(menu-bar-mode -1)
(when (display-graphic-p) ; is not terminal
  (font-spec :family "Cica" :size 12)
  (set-fontset-font (frame-parameter nil 'font)
                    'katakana-jisx0201
                    (font-spec :family "Cica" :size 12))
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    (font-spec :family "Cica" :size 12))
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(require 'linum)
(global-linum-mode 1)
(global-visual-line-mode)
(global-hl-line-mode)
(transient-mark-mode t)
(show-paren-mode 1)
(setq ring-bell-function 'ignore)

;; coding assist
(setq fill-column nil
      text-mode-hook 'turn-off-auto-fill
      default-tab-width 4 indent-tabs-mode nil
	  org-src-fontify-natively t
	  )

;; Org Mode settings
(setq org-startup-indented t)

;; startup
(setq inhibit-startup-message 1)
(setq inhibit-splash-screen t)

;; package.el settings
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)
(package-refresh-contents)

;; install packages
(package-install 'markdown-mode)

(package-install 'smartparens)
(when (require 'smartparens-config nil t)
  (smartparens-global-mode t))

(when (require 'dired-x nil t)
  (global-set-key (kbd "C-x C-j") 'dired-jump))

(package-install 'ivy)
(package-install 'counsel)
(package-install 'swiper)
(package-install 'company)
(when (require 'ivy nil t)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursize-minibuffer t)
  (setq ivy-height 3)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
  (when (require 'company nil t)
    (global-company-mode +1)
    (setq company-transformers '(company-sort-by-backend-importance))
    (setq company-idle-delay 0.1)
    (setq company-minimum-prefix-length 2)
    (setq company-selection-wrap-around t)
    (setq completion-ignore-case t)
    (setq company-dabbrev-downcase nil)
    )
  )

(package-install 'evil)
(package-install 'evil-numbers)
(package-install 'evil-org)
(defvar can-use-evil nil)
(when (require 'evil nil t)
  (setq can-use-evil t)
  (evil-mode 1)
  (defun evil-swap-key (map key1 key2)
    (let ((def1 (lookup-key map key1))
          (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk")
  (when (require 'evil-numbers nil t)
    (define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt)
    )
  (when (require 'evil-org nil t)
    (add-hook 'org-mode-hook 'evil-org-mode)
    (evil-org-set-key-theme '(navigathin insert textobjects additional calendar))
    )
  )

(package-install 'base16-theme)
(load-theme 'base16-onedark t)

(package-install 'ddskk)
(when (require 'ddskk nil t)
  (setq skk-get-jisyo-directory "~/.emacs.d/skk-jisyo")
  ; (when (directory-files skk-get-jisyo-directory)
  ;     (skk-get))
  (setq default-input-method "japanese-skk"
        skk-egg-like-newline t
		skk-use-azik t
		skk-status-indicator 'minor-mode
		skk-henkan-number-to-display-candidates 9
  )
  (define-globalized-minor-mode global-skk-latin-mode skk-latin-mode skk-latin-mode-on)
  (global-skk-latin-mode 1)
  (setq skk-use-color-cursor t)
  (setq skk-cursor-default-color  '(,(plist-get base16-onedark-colors :base08))
		skk-cursor-hiragana-color '(,(plist-get base16-onedark-colors :base0F))
		skk-cursor-katakana-color '(,(plist-get base16-onedark-colors :base0B))
		skk-cursor-jisx0201-color '(,(plist-get base16-onedark-colors :base0D))
		skk-cursor-jisx0208-color '(,(plist-get base16-onedark-colors :base09))
		skk-cursor-latin-color    '(,(plist-get base16-onedark-colors :base08))
		skk-cursor-abbrev-color   '(,(plist-get base16-onedark-colors :base0E))
		)
  (setq mode-line-format nil)
  (setq-default mode-line-format nil)
  (when (eq can-use-evil t)
	(add-hook evil-insert-state-entry-hook skk-latin-mode)
    (add-hook 'open-file
			  '(lambda()
			     (setq mode-line-format nil)
			     (setq-default mode-line-format nil)))
	)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(package-utils evil swiper ivy smartparens markdown-mode github-theme evil-org evil-numbers ddskk counsel company base16-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
