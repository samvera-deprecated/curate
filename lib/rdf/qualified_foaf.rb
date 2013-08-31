module RDF
  # This is an approximation of a refinement. At present it is perhaps not
  # adequate, but by marking the property as 'contributor#advisor' the
  # URL resolves to the DC Term 'contributor'
  class QualifiedFOAF < Vocabulary("http://xmlns.com/foaf/0.1/")
    property "account#preferred_email".to_sym
    property "account#alternate_email".to_sym
    property "phone#campus_phone_number".to_sym
    property "phone#alternate_phone_number".to_sym
  end
end
