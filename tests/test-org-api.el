(require 'org-api)
(require 'org-ql)

(describe "Org-api"
  :var (tasks)
  (before-each
    (setq tasks (org-ql-select "./tests/test.org"
                  '(and (ancestors (heading "TO DO List"))))))
  (it "get id property from the headline"
    (expect (get-headline-prop (car tasks) :ID) :to-equal "4289b702-ce64-4e76-8e01-1b8fe284af4f")))




