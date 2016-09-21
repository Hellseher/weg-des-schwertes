;;; init-local.el -- Custom local variables and functios.
;;; Created       : Thu 11 Aug 2016 22:32:01
;;; Last Modified : Wed 21 Sep 2016 23:32:15 sharlatan
;;; Author        : Sharlatan <sharlatanus@gmail.com>
;;; Maintainer(s) : Sharlatan
;;; Commentary:
;;;
;;; Combined with Purcell "A reasonable Emacs config" https://github.com/purcell/emacs.d
;;;
;;; Code:

;;; Time stemtp in the header when save the file
(setq
 time-stamp-pattern "8/Last Modified[ \t]*:\\\\?[ \t]*%03a %02d %03b %04y %02H:%02M:%02S %u\\\\?$")

(add-hook 'before-save-hook 'time-stamp)


;; http://ergoemacs.org/emacs/modernization_upcase-word.html
(defun toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
  (interactive)
  (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps") )
         (t (put this-command 'state "all lower") ) ) )
      )

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )
    )
  )

;;set this to C-x M-c
(global-set-key (kbd "C-x M-c") 'toggle-letter-case)

;;; Evil-mode
(setq evil-toggle-key "C-'")
(require-package 'evil)

;;; Org-mode
(require-package 'org-beautify-theme)
(require-package 'org-bullets)
(add-hook 'org-mode-hook (lambda () ( org-bullets-mode 1)))

(defun todo-move-to-top ()
  "Move TODO entery to the top ot the file when it is DONE."
  (interactive)
  (save-excursion)
  (org-cut-special)
  (goto-char (point-min))
  (search-forward "DONE")
  (forward-line -1)
  (org-yank))


;;; Yasnippet
;;; http://joaotavora.github.io/yasnippet/
(require-package 'yasnippet)
(yas-global-mode 1)

;;; Circe
(require-package 'circe)
(provide 'init-local)
;;; init-local.el ends here
