module RDF
  class Image < Vocabulary("http://nd.edu/image#")
    property :category
    property :location
    property :measurements
    property :material
    property :source
    property :inscription
    property :cultural_context
    property :date_photographed
  end
end

