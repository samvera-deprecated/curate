module RDF
  # This is an approximation of a refinement. At present it is perhaps not
  # adequate, but by marking the property as 'contributor#advisor' the
  # URL resolves to the DC Term 'contributor'
  class EtdMs < Vocabulary("http://www.ndltd.org/standards/metadata/etdms/1.1/")
    property :thesis
    property :degree
    property :name
    property :level
    property :discipline
    property :grantor
    property :role #not really a property of ETD-MS, but easier than having all the MARC relators
  end
end

