;; --- JSON object keys as fields ---

;; Matches keys at any nesting depth, e.g. "name", "nested", "a", "b"
(pair
  key: (string
    (string_content) @local.definition.field))

;; Each pair is a scope, so pickers nest keys under their parent key
(pair) @local.scope
