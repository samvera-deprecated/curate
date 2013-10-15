Curate.configure do |config|
  config.register_curation_concern :generic_work
  config.register_curation_concern :dataset
  config.register_curation_concern :article
  config.register_curation_concern :etd
  config.register_curation_concern :image
  config.register_curation_concern :document
end