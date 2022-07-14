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

(defun update-headline-todo (headline &optiona status)
  "Update TODO status from a headline using ID."
  (let* ((id (org-element-property :ID headline))
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

(defun parse-org-timestamp (timestamp)
  "Return timestamp for todoist."
  (let* ((unit (plist-get (car timestamp) :repeater-unit))
         (value (plist-get (car timestamp) :repeater-value)))
    (if (and unit value)
        (format "every %d %s" value unit)
      (message "missing recurring")
      )

    ))


(defun parse-headlines (headlines)
  "parse headlines into alist"
  (mapcar
   (lambda (task)
     (let* ((id (org-element-property :ID task))
            (title (org-element-property :raw-value task))
            (deadline (org-element-property :deadline task))
            (tasks (append `(("id" . ,id) ("title" . ,title) ("deadline" .,deadline)))))
       tasks))
   headlines))

(defun tasks-waiting-sync (headlines)
  "prepare headlines to sync"
  (mapcar
   (lambda (task)
     (let* ((id (org-element-property :ID task))
            (title (org-element-property :raw-value task))
            (deadline (parse-org-timestamp (cdr (org-element-property :deadline task))))
            (tags (org-element-property :tags task))
            (project-id 2226402041)
            (section )
            (tasks (append `(
                             ("type"."item_add")
                             ("temp_id" . ,id)
                             ("uuid" . ,id)
                             ("args" . (
                                        ("content" . ,title)
                                        ("project_id" . ,project-id)
                                        ("labels" . (,tags))
                                        ;;("due_string" . ,deadline)
                                        ))))))
       tasks))
   headlines))

(provide 'org-api)

