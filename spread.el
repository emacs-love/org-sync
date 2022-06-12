(require 'dash)
(require 'transient)
(require 'org)
;; (require 'org-refile) why is it gone?
(require 'json)
(require 'url)
(require 'url-http)

(defvar todos (org-ql-select "./todo.org"
                '(and (ancestors (heading "TO DO List")) )))



(setq e (car (cdr todos)))
(org-id-goto (local--task-prop (car (cdr e)) :ID))

(org-todo "DONE")


;; interate over tasks
(defvar tasks (mapcar
 (lambda (task)
   (local--task-prop (car (cdr task)) :ID))
 todos))
;
; 3 7 11

(defun complete-tasks (tasks)
  ;; Given a list complete the tasks
  (mapcar
   (lambda (task)
     (if (local--task-prop (car (cdr task)) :deadline)
         (progn
           (org-id-goto (local--task-prop (car (cdr task)) :ID))
           (org-todo "DONE"))
         (message "fail")))
   tasks)
  (save-buffer))


;; (with-temp-buffer "teste"
;;                   (pop-to-buffer "teste")
;;                   (defvar todos (org-ql-select "./todo.org"
;;                                   '(and (todo) )))
;;                   (mapcar
;;                    (lambda (task)
;;                      (insert
;;                       (concat

;;                        (local--task-prop (car (cdr task)) :todo-keyword) " - "
;;                        (car (local--task-prop (car (cdr task)) :title)) " - "
;;                        (local--task-prop (car (cdr task)) :ID)

;;                        ))
;;                      (insert "\n"))
;;                    todos))


(defun todoist--create-new-task (content due)
  "Query todoist to create new task.

CONTENT is the content string.
DUE is the human friendly due string and can be empty.
P is a prefix argument to select a project."
  (todoist--query "POST" "/tasks"
                  (append `(("content" . ,content) ("due_string" . ,due)))))
                          ;; (when p
                          ;;   `(("project_id" . ,(todoist--project-id (todoist--select-project))))))))

(todoist--create-new-task "teste" "today")

(defvar todoist-token "41b325bc657d9783059e0959462affe0959b07ff")


(defconst todoist-url
  "https://api.todoist.com/rest/v1")

(defconst todoist-timeout nil)

(defun todoist--parse-status-code ()
  "Parse the todoist response status code."
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "HTTP/1.1 \\([0-9]\\{3\\}\\)")
    (match-string-no-properties 1)))

(defun todoist--query (method endpoint &optional data)
  "Main function to interact with Todoist api.

METHOD is http method string.
ENDPOINT is the endpoint string.
DATA is the request body."
  (let ((url (concat todoist-url endpoint))
        (url-request-method method)
        (url-request-extra-headers (append`(("Authorization" . ,(concat "Bearer " todoist-token)))
                                          (when data '(("Content-Type". "application/json")))))
        (url-request-data (if data
                              (encode-coding-string (json-encode data) 'utf-8)))
        (response nil))
    (with-current-buffer (url-retrieve-synchronously url nil nil todoist-timeout)
      (let ((status (todoist--parse-status-code)))
        (unless (string-match-p "2.." status)
          (throw 'bad-response (format "Bad status code returned: %s" status))))
      (goto-char url-http-end-of-headers)
      (setq response (unless (string-equal (buffer-substring (point) (point-max)) "\n") ;; no body
                    (json-read-from-string (decode-coding-region (point) (point-max) 'utf-8 t))))
      (kill-buffer (current-buffer)) ;; kill the buffer to free up some memory
      response)))
