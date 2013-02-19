;; set the default text coding system
;; 格式化代码
;;格式化整个文件函数

(defun indent-buffer ()
 "Indent the whole buffer."
 (interactive)
 (save-excursion
 (indent-region (point-min) (point-max) nil)))

(global-set-key [f7] 'indent-buffer)

;; 显示时间
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

;; 设置大的kill ring
(setq kill-ring-max 150)

;;删除一行和复制一行
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; base op rebind
;; 移动修改成vim兼容

(global-set-key [(meta \1)] 'move-beginning-of-line)
(global-set-key [(meta \2)] 'move-end-of-line)
(global-set-key [(meta \3)] 'set-mark-command)
;; 各窗口间切换

;; Windows Cycling
(defun windmove-up-cycle()
  (interactive)
  (condition-case nil (windmove-up)
    (error (condition-case nil (windmove-down)
         (error (condition-case nil (windmove-right) (error (condition-case nil (windmove-left) (error (windmove-up))))))))))

(defun windmove-down-cycle()
  (interactive)
  (condition-case nil (windmove-down)
    (error (condition-case nil (windmove-up)
         (error (condition-case nil (windmove-left) (error (condition-case nil (windmove-right) (error (windmove-down))))))))))

(defun windmove-right-cycle()
  (interactive)
  (condition-case nil (windmove-right)
    (error (condition-case nil (windmove-left)
         (error (condition-case nil (windmove-up) (error (condition-case nil (windmove-down) (error (windmove-right))))))))))

(defun windmove-left-cycle()
  (interactive)
  (condition-case nil (windmove-left)
    (error (condition-case nil (windmove-right)
         (error (condition-case nil (windmove-down) (error (condition-case nil (windmove-up) (error (windmove-left))))))))))

(global-set-key (kbd "C-x <up>") 'windmove-up-cycle)
(global-set-key (kbd "C-x <down>") 'windmove-down-cycle)
(global-set-key (kbd "C-x <right>") 'windmove-right-cycle)
(global-set-key (kbd "C-x <left>") 'windmove-left-cycle)

;; 支持外部程序和emacs的粘贴
(setq x-select-enable-clipboard t)

;; 开启语法高亮
(font-lock-mode t)

;; 设置行号
(global-linum-mode 1)
(setq linum-format "%4d| ")

(require 'package)
(package-initialize)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(setq default-buffer-file-coding-system 'utf-8)

(prefer-coding-system 'utf-8)

;;将clojure-emacs设置到加载路径
;;(add-to-list 'load-path "~/.emacs.d/path/to/clojure-emacs")
;;(require 'clojure-emacs-init)

(add-to-list 'load-path "~/.emacs.d/el-get/popup")

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync)

;; undo-tree
(add-to-list 'load-path "~/.emacs.d")
(require 'undo-tree)
(global-undo-tree-mode)

(add-to-list 'load-path "~/.emacs.d/evil")
    (require 'evil)
    (evil-mode 1)

;;erlware
(add-to-list 'load-path "~/.emacs.d/el-get/erlware-mode")
(setq erlang-man-root-dir "/usr/lib/man")
(setq exec-path (cons "/usr/local/bin" exec-path))
(require 'erlang-start)


;;lua-mode
(add-to-list 'load-path "~/.emacs.d/el-get/lua-mode")

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;auto-complete
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/ac-dict")
(ac-config-default)

;;添加erlware-mode 到 自动完成 ac-modes
(add-to-list 'ac-modes 'erlware-mode)
(add-to-list 'ac-modes 'erlang-mode)

;;viper
;;(add-to-list 'load-path "~/.emacs.d/viper")
;;(setq viper-mode t)
;;(setq viper-ex-style-editing nil)
;;(require 'viper)

;;vimpluse
;;(add-to-list 'load-path "~/.emacs.d/el-get/vimpulse")
;;(require 'vimpulse)

;;slime
(add-to-list 'load-path "~/.emacs.d/slime")
(require 'slime-autoloads)

(eval-after-load "slime"
  '(progn
    (add-to-list 'load-path "/.emacs.d/slime/contrib")
    (slime-setup '(slime-fancy slime-banner))
    (setq slime-complete-symbol*-fancy t)
    (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)))

(setq inferior-lisp-program "alisp")
