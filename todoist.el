(require 'request)
(require 'ts)


(defgroup org-sync nil
  "Interface for sync org taks with clound."
  :group 'extensions
  :group 'tools
  :link '(url-link :tag "Repository" "https://github.com/emacs-love/org-sync"))

(defcustom org-sync-todoist-tags nil
  "Id of todoist tags."
  :group 'todoist
  :type '(alist :key-type string :value-type (group string)))

(defconst todoist-url
  "https://api.todoist.com/sync/v8")

(defun get-tags-ids (tags)
  "Return timestamp for todoist."
  (if tags
      (let* ((id-list '())
            (tags-list (mapcar
                        (lambda (tag)
                          (org-no-properties tag))
                        (org-element-property :tags (car tasks)))))
        (mapcar
         (lambda (tag)
           (setq id-list (append (car (cdr (assoc tag org-sync-todoist-tags)))))) tags-list))
    "[]"))

(defun get-due-string (timestamp)
  "Return timestamp for todoist."
  (let* ((unit (plist-get (car (cdr timestamp)) :repeater-unit))
         (value (plist-get (car (cdr timestamp)) :repeater-value)))
    (if (and unit value)
        (format "every %d %s" value unit)
      "")))

(defun get-due-date (timestamp)
  "Return timestamp for todoist."
  (ts-format "%Y-%m-%d" (ts-parse-org-element timestamp)))

(defun tasks-waiting-sync (headlines)
  "prepare headlines to sync"
  (mapcar
   (lambda (task)
     (let* ((title (org-element-property :raw-value task))
            (due-string (get-due-string (org-element-property :deadline task)))
            (due-date (get-due-date (org-element-property :deadline task)))
            (tags (get-tags-ids (org-element-property :tags task)))
            (temp-id (org-id-new))
            (project-id "2226402041")
            (section )
            (tasks (append `(
                             ("type"."item_add")
                             ("temp_id" . ,temp-id)
                             ("uuid" . ,(substring temp-id 26 35))
                             ("args" . (
                                        ("project_id" . ,project-id)
                                        ("content" . ,title)
                                        ("labels" . ,tags)
                                        ("due" . (("date" . ,due-date)))
                                        ))))))
       tasks))
   headlines))


(defun todoist-query (method endpoint &optional data)
  "Main function to interact with Todoist api."

  (request (concat todoist-url endpoint)
    :type method
    :headers `( ("Authorization" . ,(concat "Bearer " todoist-token)))
    :data data
    :sync t
    :parser 'json-read
    :error
    (cl-function (lambda (&rest args &key error-thrown &allow-other-keys)
                   (message "Got error: %S" error-thrown)))
    :status-code '((400 . (lambda (&rest _) (message "Got 400.")))
                   (418 . (lambda (&rest _) (message "Got 418."))))))


(defun push-tasks (tasks)
  "Send tasks to Todoist."
  (request-response-data
   (todoist-query
    "POST"
    "/sync"
    `(("sync_token" . "*") ("resource_types" . "[\"items\"]")
      ("commands" . ,(json-encode (tasks-waiting-sync tasks)))))))

