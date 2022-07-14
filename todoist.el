(require 'request)

(defconst todoist-url
  ;;"https://api.todoist.com/rest/v1"
  "https://api.todoist.com/sync/v8")

(defun todoist-query (method endpoint &optional data)
  "Main function to interact with Todoist api."

  (request (concat todoist-url endpoint)
    :type method
    :headers `( ("Authorization" . ,(concat "Bearer " todoist-token)))
    :data data
    :sync t
    :parser 'json-read))


(defun push-tasks (tasks)
  "Send tasks to Todoist."
  ;; (let* (
  ;;        (data (todoist-query "POST" "/sync" `(("sync_token" . "*") ("resource_types" . "[\"items\"]") ("commands" . ,(json-encode (tasks-waiting-sync tasks))))))
  ;;        (parsed-response (request-response-data data))
  ;;        (sync-token (alist-get 'sync_token parsed-response))
  ;;        (id-mapping (alist-get 'temp_id_mapping parsed-response))
  ;;        (response (append `(("sync-token" . ,sync-token) ("id-mapping" . ,id-mapping)))
  ;;                  )
  ;;   response)))
  (request-response-data (todoist-query "POST" "/sync" `(("sync_token" . "*") ("resource_types" . "[\"items\"]") ("commands" . ,(json-encode (tasks-waiting-sync tasks)))))))

