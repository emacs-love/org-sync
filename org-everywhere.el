(load-file "./org-api.el")
(load-file "./todoist.el")


(defvar todos (org-ql-select "./todo.org"
                '(and (ancestors (heading "TO DO List")) )))

(print (parse-headlines todos))

(todoist-query "POST" "/sync" `(("sync_token" . "*") ("resource_types" . "[\"items\"]") ("commands" . ,(json-encode (setup-sync-headlines todos)))))
(defun complete-tasks (tasks)
  ;; Given a list complete the tasks
  (mapcar
   (lambda (task)
     (if (get-headline-prop task :deadline)
         (update-headline-todo task "TODO")
       (message "fail")))
   tasks))




