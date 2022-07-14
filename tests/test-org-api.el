(require 'org-api)
(require 'org-ql)

(defun org-ql-test-data-buffer (filename)
  "Return buffer visiting FILENAME.
FILENAME should be a file in the \"tests\" directory."
  (->> (locate-dominating-file default-directory ".git")
    (expand-file-name "tests")
    (expand-file-name filename)
    find-file-noselect))

(describe "Org-api"
  :var (tasks)
  (before-each
    (setq tasks (org-ql-select "./tests/test.org"
                  '(and (ancestors (heading "TO DO List"))))))

  (it "parse a org timestamp"
    (let (
          (timestamp (cdr (org-element-property :deadline (car tasks)))))
      (expect (parse-org-timestamp timestamp) :to-equal t))))
