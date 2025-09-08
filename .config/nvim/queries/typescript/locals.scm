;; --- Type Aliases as Locals ---

;; Capture type alias definitions
(type_alias_declaration
  name: (type_identifier) @local.definition)

;; Capture references to type aliases
(type_identifier) @local.reference
