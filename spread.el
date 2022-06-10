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

;; 3 7 11


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

(complete-tasks todos)


(with-temp-buffer "teste"
                  (pop-to-buffer "teste")
                  (defvar todos (org-ql-select "./todo.org"
                                  '(and (todo) )))
                  (mapcar
                   (lambda (task)
                     (insert
                      (concat

                       (local--task-prop (car (cdr task)) :todo-keyword) " - "
                       (car (local--task-prop (car (cdr task)) :title)) " - "
                       (local--task-prop (car (cdr task)) :ID)

                       ))
                     (insert "\n"))
                   todos))




(defun local--task-prop (task prop)
  "Get the local task prop.
   TASK is the plist from a org header from org-element-headline-parser."
  (plist-get task prop))

