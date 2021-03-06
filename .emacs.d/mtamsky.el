;; Things to try or start using:
;; package: https://github.com/jwiegley/use-package
;; package: helm (helm-show-kill-ring, helm-search-google)
;; package: guide-keys


(starter-kit-load "js")

(global-set-key "\C-\\" 'help-command)
(global-set-key "\C-x^" 'enlarge-window)

(setq text-quoting-style 'straight)

;; If we ever need it
;; via: https://ghc.haskell.org/trac/ghc/ticket/2507#comment:27
;;
;; (setq locale-coding-system 'utf-8)
;; (set-terminal-coding-system 'utf-8-unix)
;; (set-keyboard-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)


;; when SCREEN set && not emacs-client
;; (global-set-key "\C-x\C-c

;; from https://github.com/stsquad/emacs_chrome/wiki/edit-server
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'edit-server)
(edit-server-start)

(require 'vc-hg)

;; from https://stackoverflow.com/questions/9656311
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
;; TODO(tamsky): add this new binding to ediff HELP menu:
(defun add-B-to-ediff-mode-map () (define-key ediff-mode-map "B" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-B-to-ediff-mode-map)


;; https://github.com/nex3/perspective-el
;; (package-install 'perspective) moved to custom.el
(require 'perspective)

;; (package-install 'use-package) moved to custom.el
(require 'use-package)
(use-package terraform-mode
             :ensure
             :config (progn
                       (setq terraform-indent-level 4)
                       (add-to-list 'auto-mode-alist '("\\.tfstate\\'" . json-mode))))

(use-package markdown-mode
             :ensure t
             :commands (markdown-mode gfm-mode)
             :mode (("README\\.md\\'" . gfm-mode)
                    ("\\.md\\'" . markdown-mode)
                    ("\\.markdown\\'" . markdown-mode))
             :init (setq markdown-command "multimarkdown"))

(add-to-list 'magic-fallback-mode-alist '("#cloud-config" . conf-space-mode))

;; package default is 'scp':
(setq tramp-default-method "ssh")

;; org mode stuff

(org-babel-do-load-languages
 'org-babel-load-languages
; '((shell . t)) ; 'shell' may be bunk, unless 'sh' is bunk; one of these must be right
 '((sh . t)))



;; from reefer
(use-package ffap
 :config
;; https://github.com/technomancy/emacs-starter-kit/issues/39
;; What a stupid default.
     (setq ffap-machine-p-known 'reject)

  (defvar ffap-c-commment-regexp "^/\\*+"
    "Matches an opening C-style comment, like \"/***\".")

  (defadvice ffap-file-at-point (after avoid-c-comments activate)
    "Don't return paths like \"/******\" unless they actually exist.
      This fixes the bug where ido would try to suggest a C-style
      comment as a filename."
    (ignore-errors
      (when (and ad-return-value
                 (string-match-p ffap-c-commment-regexp
                                 ad-return-value)
                 (not (ffap-file-exists-string ad-return-value)))
        (setq ad-return-value nil)))))


;; figuring out terminal stuff for screen:
(if (not window-system)		;; Only use in tty-sessions.
    (progn
      (defvar arrow-keys-map (make-sparse-keymap) "Keymap for screen+xterm command+arrow keys")
      (define-key esc-map "[1;9" arrow-keys-map)
      (define-key arrow-keys-map "A" 'backward-paragraph)
      (define-key arrow-keys-map "B" 'forward-paragraph)
      (define-key arrow-keys-map "C" 'right-word)
      (define-key arrow-keys-map "D" 'left-word)
      )
  )

(server-start)

;; Mostly to keep auto-fill off in yaml mode.
(remove-hook 'text-mode-hook #'turn-on-auto-fill)

;; waka
(use-package wakatime-mode)

;;TIP
;; revert-buffer-with-coding-system
;; try using 'iso-8859-1' when debugging utf-8 documents
;;
