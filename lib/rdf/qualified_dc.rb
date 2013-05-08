module RDF
  # This is an approximation of a refinement. At present it is perhaps not
  # adequate, but by marking the property as 'contributor#advisor' the
  # URL resolves to the DC Term 'contributor'
  class QualifiedDC < Vocabulary("http://purl.org/dc/terms/")
    property "contributor#advisor".to_sym
  end
end