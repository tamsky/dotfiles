; Things to try or start using:
; package: https://github.com/jwiegley/use-package
; package: helm (helm-show-kill-ring, helm-search-google)
; package: guide-keys


(starter-kit-load "js")

(global-set-key "\C-\\" 'help-command)
(global-set-key "\C-x^" 'enlarge-window)

;; when SCREEN set && not emacs-client
;; (global-set-key "\C-x\C-c

; from https://github.com/stsquad/emacs_chrome/wiki/edit-server
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'edit-server)
(edit-server-start)

(require 'vc-hg)
(load-file "~/src/github/lisp/markdown-mode/markdown-mode.el")

; https://github.com/nex3/perspective-el
(require 'perspective)

(require 'use-package)
(use-package terraform-mode
             :ensure
             :config (progn
                       (setq terraform-indent-level 4)
                       (add-to-list 'auto-mode-alist '("\\.tfstate\\'" . json-mode))))

(add-to-list 'magic-fallback-mode-alist '("#cloud-config" . conf-space-mode))

(server-start)
