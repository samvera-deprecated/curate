require Sufia::Engine.root.join('lib/sufia/jobs/characterize_job')

# I really don't want to touch much of Sufia's underworkings. In doing this
# I'm able to mimic the #super behavior.
#
# More on this method at:
# http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
class CharacterizeJob
  sufia_run = self.instance_method(:run)
  define_method :run do
    begin
      sufia_run.bind(self).call
    rescue AntiVirusScanner::VirusDetected => e
      GenericFile.find(generic_file_id).destroy
      raise e
    end
  end
end
