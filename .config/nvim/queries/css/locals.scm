;; --- CSS class & id selectors, plus CSS custom properties as locals ---

(class_selector
  (class_name) @local.definition.type)

(id_selector
  (id_name) @local.definition.type)

((declaration
   (property_name) @local.definition.var)
 (#match? @local.definition.var "^--"))
