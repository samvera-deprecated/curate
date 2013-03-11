require Sufia::Engine.root.join('app/models/datastreams/file_content_datastream')
class FileContentDatastream

  def run_fits!(file_path)
    anti_virus_scanner(file_path).call
    if Rails.configuration.respond_to?(:fits_runner)
      Rails.configuration.fits_runner.call(file_path)
    else
      super(file_path)
    end
  end

  protected
  def anti_virus_scanner(file_path)
    AntiVirusScanner.new(self, file_path)
  end
end
