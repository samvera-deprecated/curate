module RDF
  # This is an approximation of a refinement. At present it is perhaps not
  # adequate, but by marking the property as 'contributor#advisor' the
  # URL resolves to the DC Term 'contributor'
  class QualifiedDC < Vocabulary("http://purl.org/dc/terms/")
    property "type".to_sym
    property "contributor#advisor".to_sym
    property "creator#author".to_sym
    property "rights#permissions".to_sym
    property "contributor#author".to_sym
    property "publisher#country".to_sym
    property "identifier#doi".to_sym
    property "identifier#issn".to_sym
    property "contributor#repository".to_sym
    property "contributor#institution".to_sym
    property "relation#ispartof".to_sym
    property "title#alternate".to_sym
    property "date#created".to_sym
    property "format#mimetype".to_sym
    property "format#extent".to_sym
    property "description#technical".to_sym
    property "description#abstract".to_sym
    property "description#note".to_sym
    property "description#methodology".to_sym
    property "description#data_processing".to_sym
    property "description#file_structure".to_sym
    property "description#variable_list".to_sym
    property "description#code_list".to_sym
    property "date#digitized".to_sym
    property "coverage#spatial".to_sym
    property "coverage#temporal".to_sym
  end
end
