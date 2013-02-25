class CharacterizationJob < BaseJob
  def queue_name
    :characterize
  end

  attr_reader :curation_concern

  def initialize(curation_concern_id)
    @curation_concern = ActiveFedora::Base.find(curation_concern_id, cast: true)
  end

  def run
    curation_concern.characterize
    curation_concern.create_thumbnail
    if curation_concern.video?
      Sufia.queue.push(TranscodeVideoJob.new(curation_concern_id, 'content'))
    end
  end
end