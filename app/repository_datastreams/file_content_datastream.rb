require Sufia::Engine.root.join('app/models/datastreams/file_content_datastream')
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

  def run_fits!(file_path)
    anti_virus_scanner(file_path).call
    fits_runner.call(file_path)
  end

  protected
  def anti_virus_scanner(file_path)
    AntiVirusScanner.new(self, file_path)
  end

  define_method :fits_runner do
    if Rails.configuration.respond_to?(:fits_runner)
      Rails.configuration.fits_runner
    else
      sufia_run_fits.bind(self)
    end
  end

end
