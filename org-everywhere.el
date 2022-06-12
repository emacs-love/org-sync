(add-to-list 'load-path "./org-api.el")


(defvar todos (org-ql-select "./todo.org"
                '(and (ancestors (heading "TO DO List")) )))


(defun complete-tasks (tasks)
  ;; Given a list complete the tasks
  (mapcar
   (lambda (task)
     (if (get-headline-prop task :deadline)
         (update-headline-todo task "TODO")
       (message "fail")))
   tasks))

(complete-tasks todos)


(mapcar
 (lambda (task) (get-headline-prop task :raw-value))

 todos)
