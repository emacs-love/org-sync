(require 'org-api)
(require 'org-ql)

(describe "Org-api"
  :var (tasks)
  (before-each
    (setq tasks (org-ql-select "./tests/test.org"
                  '(and (ancestors (heading "TO DO List"))))))
  (it "get id property from the headline"
    (expect (get-headline-prop (car tasks) :ID) :to-equal "4289b702-ce64-4e76-8e01-1b8fe284af4f"))

  (it "get a alist with id and title from the org-ql"
    (let (
          (parsed-list (parse-headlines tasks))
          (expected-list '( (("id" . "4289b702-ce64-4e76-8e01-1b8fe284af4f" ) ("title" . "Test 1")) (("id" . "f7f7a2f5-6cd6-4a1a-8ec7-000998c027e2") ("title" . "Test 2")) )))
    (expect parsed-list :to-equal expected-list))))

