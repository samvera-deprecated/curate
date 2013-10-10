class CurationConcern::EtdsController < CurationConcern::GenericWorksController
  self.curation_concern_type = Etd

  def setup_form
    curation_concern.creators << Person.new
  end

end
