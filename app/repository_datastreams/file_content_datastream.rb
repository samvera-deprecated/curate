require Sufia::Models::Engine.root.join('app/models/datastreams/file_content_datastream')
# I really don't want to touch much of Sufia's underworkings. In doing this
# I'm able to mimic the #super behavior.
#
# More on this method at:
# http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
class FileContentDatastream

  # Yes, I could be using super, however that assumes a working knowledge
  # of how the FileContentDatastream is actually crafted (namely via
  # ActiveSupport::Concern)
  sufia_run_fits = self.instance_method(:run_fits!)

  # This is where I chose to insert the anti-virus. My reason being that the
  # caller of this method is getting the Fedora datastream and writing it to
  # a temp file for characterization; So to ease the load, I'm piggy backing
  # on that behavior and first running an Anti-Virus scanner
  def run_fits!(file_path)
    anti_virus_scanner.call(file_path)
    characterization_runner.call(file_path)
  end

  protected
  def anti_virus_scanner
    AntiVirusScanner.new(self)
  end

  define_method :characterization_runner do
    if Rails.configuration.respond_to?(:default_characterization_runner)
      Rails.configuration.default_characterization_runner
    else
      sufia_run_fits.bind(self)
    end
  end

end
