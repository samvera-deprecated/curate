require Sufia::Engine.root.join('lib/sufia/jobs/characterize_job')

# I really don't want to touch much of Sufia's underworkings. In doing this
# I'm able to mimic the #super behavior.
#
# More on this method at:
# http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
class CharacterizeJob
  sufia_run = self.instance_method(:run)

  # In a perfect world, I would like this method to be a chain of methods,
  # first run anti-virus, then run characterization, then thumbnails, etc.
  # However, I am also wanting to reduce the messaging between Fedora and
  # the system that runs this job, so I'm defering to the FileContentDatastream
  # to handle this.
  define_method :run do
    begin
      sufia_run.bind(self).call
    rescue AntiVirusScanner::VirusDetected => e
      GenericFile.find(generic_file_id).destroy
      raise e
    end
  end
end
