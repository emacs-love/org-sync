(defvar todos (org-ql-select "./todo.org"
                '(and (ancestors (heading "TO DO List")) )))

(setq e (car (cdr todos)))
(org-id-goto (local--task-prop (car (cdr e)) :ID))

(org-todo "DONE")

;; interate over tasks
(mapcar
 (lambda (task)
   (local--task-prop (car (cdr task)) :title))
 todos)


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

