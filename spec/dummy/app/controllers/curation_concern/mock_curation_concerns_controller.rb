class CurationConcern::MockCurationConcernsController < CurationConcern::BaseController
  def curation_concern
    @curation_concern ||= MockCurationConcern.find(params[:id])
  end

  def show
    render text: "<html><body>#{curation_concern.to_s}</body></html>"
  end
end