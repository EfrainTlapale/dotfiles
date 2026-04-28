;; --- SCSS class selectors, mixins & CSS custom properties as locals ---

(class_selector
  (class_name) @local.definition.type)

(id_selector
  (id_name) @local.definition.type)

(mixin_statement
  (name) @local.definition.macro)

((declaration
   (property_name) @local.definition.var)
 (#match? @local.definition.var "^--"))
