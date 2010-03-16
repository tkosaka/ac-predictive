;;; ac-predictive.el --- Auto-complete source for predictive-mode

;; Copyright (C) 2009-2010  KOSAKA Tomohiko

;; Author: KOSAKA Tomohiko <tomohiko.kosaka@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This provides an auto-complete source for predictive-mode.
;; For the full information for predictive-mode, 
;; see http://www.dr-qubit.org/emacs.php#predictive


;;; Requirements:
;;; 
;;; 1. predictive-mode.el.
;;; 2. auto-complete.el (version 1.2 or higher).

;;; Installation:
;;
;; 1. Put ac-predictive.el into a directory that Emacs recognizes as a part of `load-path'.
;; You can also byte-compile this file.
;;
;; 2. Put the following into your init file (.emacs.el).
;;
;; (require 'ac-predictive)
;; (ac-predictive-init)


;;; * Important Notice:
;; 1. One of the important features of predictive-mode is learning predicted candidates, 
;;    but you cannot make dictionaries learn by using ac-predictive.
;; 2. The variable `predictive-auto-complete' is set to nil by loading this file.

;;; Setting:
;;
;; In default, ac-predictive will start getting predicted candidates 
;; by three strokes of keys.
;; If you want to change it, set the source like the following:
;;
;; (setq ac-source-predictive
;;       '((candidates . ac-predictive-candidates)
;;         (symbol . "p")
;;         (requires . 2)))
;;
;; This setting enables you to start by only two key-strokes.


;;; Code:

(require 'auto-complete)
(require 'predictive)

(setq predictive-auto-complete nil)

(defun ac-predictive-error (&optional var)
  (ignore-errors
    (message "ac-predictive error: %s" var)
    var))

(defun ac-predictive-candidates (&optional maxnum)
  "Retrieve predicted candidates by `predictive-comlete'."
  (let ((candidates nil))
    (condition-case var
        (setq candidates 
              (predictive-complete ac-prefix maxnum))
      (error (ac-predictive-error var)))
    candidates))

(ac-define-source predictive
  '((candidates . ac-predictive-candidates)
    (requires . 3)
    (symbol . "p")))

(defun ac-predictive-setup (&optional disable)
  "Add `ac-source-predictive' to the last of `ac-sources' when `disable' is nil.
   When `disable' is non-nil, remove `ac-source-predictive' from `ac-sources'."
  (if disable
      (setq ac-sources (delete 'ac-source-predictive ac-sources))
    (add-to-list 'ac-sources 'ac-source-predictive t)))

(defun ac-predictive-init ()
  (add-hook 'predictive-mode-hook 'ac-predictive-setup)
  (add-hook 'predictive-mode-disable-hook '(lambda ()
                                             (ac-predictive-setup t))))

(provide 'ac-predictive)
;;; ac-predictive.el ends here
