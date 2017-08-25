;;; packages.el --- Rust Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Chris Hoeppner <me@mkaito.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq rustrls-packages
  '(
    lsp-mode
    (lsp-mode :requires flycheck)
    lsp-rust
    cargo
    company
    flycheck
    (flycheck-rust :requires flycheck)
    ggtags
    helm-gtags
    rust-mode
    toml-mode
    ))

(defun rustrls/init-cargo ()
  (use-package cargo
    :defer t
    :init
    (progn
      (spacemacs/declare-prefix-for-mode 'rust-mode "mc" "cargo")
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "c." 'cargo-process-repeat
        "cC" 'cargo-process-clean
        "cX" 'cargo-process-run-example
        "cc" 'cargo-process-build
        "cd" 'cargo-process-doc
        "ce" 'cargo-process-bench
        "cf" 'cargo-process-current-test
        "cf" 'cargo-process-fmt
        "ci" 'cargo-process-init
        "cn" 'cargo-process-new
        "co" 'cargo-process-current-file-tests
        "cs" 'cargo-process-search
        "cu" 'cargo-process-update
        "cx" 'cargo-process-run
        "t" 'cargo-process-test))))

(defun rustrls/post-init-flycheck ()
  (spacemacs/enable-flycheck 'rust-mode))

(defun rustrls/init-flycheck-rust ()
  (use-package flycheck-rust
    :defer t
    :init (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(defun rustrls/post-init-ggtags ()
  (add-hook 'rust-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun rustrls/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'rust-mode))

(defun rustrls/init-rust-mode ()
  (use-package rust-mode
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "=" 'rust-format-buffer
        "q" 'spacemacs/rust-quick-run)

      (evil-define-key 'insert rust-mode-map
        (kbd ".") 'rustrls/completing-dot))))

(defun rustrls/init-toml-mode ()
  (use-package toml-mode
    :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"))

(defun rustrls/post-init-company ()
  (spacemacs|add-company-backends
    :backends company-capf
    :modes rust-mode
    :variables company-tooltip-align-annotations t))

(defun rustrls/post-init-smartparens ()
  (with-eval-after-load 'smartparens
    ;; Don't pair lifetime specifiers
    (sp-local-pair 'rust-mode "'" nil :actions nil)))

(defun rustrls/init-lsp-mode ()
  (use-package lsp-mode
    :init
    (progn
      (spacemacs/add-to-hook 'rust-mode-hook '((lambda () (funcall rustrls-lsp-mode-hook))))
      (spacemacs/set-leader-keys-for-major-mode 'rust-mode
        "r" 'lsp-rename)
    )
    :config
    (use-package lsp-flycheck
      :ensure f ; comes with lsp-mode
      :after flycheck)))

(defun rustrls/init-lsp-rust ()
  (use-package lsp-rust
    :after lsp-mode))
