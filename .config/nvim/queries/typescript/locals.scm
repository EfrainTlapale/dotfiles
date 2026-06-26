;; --- Type Aliases as Locals ---

;; Capture type alias definitions
(type_alias_declaration
  name: (type_identifier) @local.definition.type)

(interface_declaration
  name: (type_identifier) @local.definition.type)

;; Capture shorthand properties inside defined parameter objects
(formal_parameters
  (required_parameter
    (object_pattern
      (shorthand_property_identifier_pattern) @local.definition.parameter)))


(formal_parameters (optional_parameter (identifier) @local.definition.parameter)) 
(formal_parameters (required_parameter (identifier) @local.definition.parameter)) 

(variable_declarator
  (object_pattern
    (shorthand_property_identifier_pattern) @local.definition.parameter))

(variable_declarator
  (array_pattern
    (identifier) @local.definition.var))

;; Capture the loop variable in `for (const item of inbox)`
(for_in_statement
  left: (identifier) @local.definition.var)

;; Capture destructured loop variables, e.g. `for (const [k, v] of map)`
(for_in_statement
  left: (array_pattern
    (identifier) @local.definition.var))

;; Capture destructured loop variables, e.g. `for (const { id } of inbox)`
(for_in_statement
  left: (object_pattern
    (shorthand_property_identifier_pattern) @local.definition.var))

;; Capture renamed object destructuring, e.g. `for (const { id: x } of inbox)`
(for_in_statement
  left: (object_pattern
    (pair_pattern
      value: (identifier) @local.definition.var)))


(
  (variable_declarator
    value: (object
      (pair
        key: (property_identifier) @local.definition.field)))
)

(
  (variable_declarator
    value: (object
      (pair
        key: (string (string_fragment) @local.definition.field))))
)

(
  (variable_declarator
    value: (as_expression
      (object
        (pair
          key: (property_identifier) @local.definition.field))))
)

(
  (variable_declarator
    value: (as_expression
      (object
        (pair
          key: (string (string_fragment) @local.definition.field)))))
)

(property_signature
  name: (string
    (string_fragment) @local.definition.field
  )
)



;; 1. Matches top-level keys (e.g., "components")
(interface_declaration
  body: (interface_body
    (property_signature
      name: (property_identifier) @local.definition.field
    )
  )
)

;; 2. Matches nested keys (e.g., "Aoi")
(object_type
  (property_signature
    name: (property_identifier) @local.definition.field
  )
)
