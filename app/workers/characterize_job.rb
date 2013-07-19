require Sufia::Models::Engine.root.join('lib/sufia/models/jobs/characterize_job')

class CharacterizeJob
  module WithAntiVirusHandler
    def run
      super
    rescue AntiVirusScanner::VirusDetected => e
      GenericFile.find(generic_file_id).destroy
      raise e
    end
  end
  include(WithAntiVirusHandler) unless included_modules.include?(WithAntiVirusHandler)
end
