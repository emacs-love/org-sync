(load-file "./org-api.el")
(load-file "./todoist.el")

;;Search TODO items
;; (defvar todos (org-ql-select "~/Projects/org-files/journal/2022.org"
;;                 '(and
;;                   (todo)
;;                   (ancestors (heading "Task")) )))

(defvar tasks (org-ql-select "./tests/test.org"
                  '(and (ancestors (heading "TO DO List")))))


(print (tasks-waiting-sync tasks))
(print (parse-headlines tasks))
(plist-get (car (cdr (org-element-property :deadline (car todos)))) :raw-value)

(plist-get (car (cdr (org-element-property :deadline (car todos)))) :repeater-type)
   (car (cdr (org-element-property :deadline (car todos))))

(print (push-tasks tasks))


(request-response-data (todoist-query "POST" "/sync" `(("sync_token" . "*") ("resource_types" . "[\"items\"]") ("commands" . ,(json-encode (tasks-waiting-sync tasks))))))

(defun complete-tasks (tasks)
  ;; Given a list complete the tasksa
  (mapcar
   (lambda (task)
     (if (equal (get-headline-prop task :todo-type) 'todo)
         (update-headline-todo task "DONE")
       (message "fail")))
   tasks))


(complete-tasks todos)



(defun recurring-types (tasks)
  ;; Given a list complete the tasks
  (mapcar
   (lambda (task)
     (print (parse-org-timestamp (cdr (org-element-property :deadline task)))))
     tasks))

(recurring-types tasks)
