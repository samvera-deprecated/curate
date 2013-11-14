require Sufia::Models::Engine.root.join('app/models/datastreams/file_content_datastream')

class FileContentDatastream

  def extract_metadata
    return unless has_content?
    # I want to run Clam first, let that possibly raise exceptions
    # Then run fits and return that
    clam, fits = Hydra::FileCharacterization.characterize(content, filename_for_characterization.join(""), :clam, :fits) do |config|
      config[:clam] = antivirus_runner
      config[:fits] = characterization_runner
    end
    fits
  end

  protected

  def antivirus_runner
    AntiVirusScanner.new(self)
  end

  def characterization_runner
    if Curate.configuration.characterization_runner.respond_to?(:call)
      Curate.configuration.characterization_runner
    else
      Sufia.config.fits_path
    end
  end

end
