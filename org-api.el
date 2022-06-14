;;; -*- lexical-binding: t; -*-
;;; org-everywhere

(defun get-headline-prop (headline prop)
  "Get the headline prop.
   headline is the plist from a org headline from org-element-headline-parser."
  (plist-get (car (cdr headline)) prop))

(defun update-headline-todo (headline status)
  "Update TODO status from a headline using ID."

  (with-temp-buffer
    (set-buffer (find-file-noselect (car (org-id-find (get-headline-prop headline :ID)))))
    (goto-char (cdr (org-id-find (get-headline-prop headline :ID))))
    (move-marker (org-id-find (get-headline-prop headline :ID) 'marker) nil)
    (org-todo status)
    (save-buffer)))

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



