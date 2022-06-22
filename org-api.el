;;; org-api.el --- "CRUD" API for org-mode -*- lexical-binding: t -*-

;; Author: Guilherme Guerra <guilherme.ga@gmail.com>
;; URL: https://emacs.love/org-api
;; Version: 0.0.1
;;
;; Copyright (C) 2022  Guilherme Guerra
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;;
;;; Code:

(defun get-headline-prop (headline prop)
  "Get the headline prop.
   headline is the plist from a org headline from org-element-headline-parser."
  (plist-get (car (cdr headline)) prop))

(defun update-headline-todo (headline &optional status)
  "Update TODO status from a headline using ID."
  (let* ((id (get-headline-prop headline :ID))
         (location (org-id-find id))
         (file (car (org-id-find id)))
         (pos (cdr (org-id-find id))))
    (if (and id location)
      (progn
        (with-temp-buffer
           (set-buffer (find-file-noselect file))
           (goto-char pos)
           (org-todo status)
           (save-buffer)))
       (message "ID %s not found" id))))


(defun parse-headlines (headlines)
  "parse headlines into alist"
  (mapcar
   (lambda (task)
     (let* ((id (get-headline-prop task :ID))
            (title (get-headline-prop task :raw-value))
            (deadline (get-headline-prop task :deadline))
            (tasks (append `(("id" . ,id) ("title" . ,title)))))
       tasks))
   headlines))

(defun setup-sync-headlines (headlines)
  "parse headlines into alist"
  (mapcar
   (lambda (task)
     (let* ((id (get-headline-prop task :ID))
            (title (get-headline-prop task :raw-value))
            (deadline (get-headline-prop task :deadline))
            (tasks (append `(
                             ("type"."item_add")
                             ("temp_id" . ,id)
                             ("uuid" . ,id)
                             ("args" . (("content" . ,title)))))))
       tasks))
   headlines))

(defun org-api ()
  "Call out other general customization functions."
  (get-headline-prop)
  (update-headline-todo))

(provide 'org-api)



