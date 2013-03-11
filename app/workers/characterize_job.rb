require Sufia::Engine.root.join('lib/sufia/jobs/characterize_job')
class CharacterizeJob

  def queue_name
    :characterize
  end

  attr_reader :generic_file

  def initialize(generic_file_id)
    self.generic_file_id = generic_file_id
  end

  def run
    characterize
    create_thumbnail
    transcode_video
  end

  def generic_file
    @generic_file ||= GenericFile.find(generic_file_id)
  end

  protected
  def characterize
    begin
      generic_file.characterize
    rescue AntiVirusScanner::VirusDetected => e
      generic_file.destroy
      raise e
    end
  end

  def create_thumbnail
    generic_file.create_thumbnail
  end

  def transcode_video
    if generic_file.video?
      Sufia.queue.push(TranscodeVideoJob.new(generic_file_id, 'content'))
    end
  end
end
