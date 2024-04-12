;; extends

(attribute
  (attribute_name) @_attribute_name
  (quoted_attribute_value 
    (attribute_value) @attribute_ref_value
    (#eq? @_attribute_name "ref"))
  )
