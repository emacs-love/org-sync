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



(defun org-api ()
  "Call out other general customization functions."
  (get-headline-prop)
  (update-headline-todo))

(provide 'org-api)



