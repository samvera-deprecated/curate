module EnvironmentOverride
  module_function
  def with_anti_virus_scanner(success = true)
    before_override = Curate.configuration.default_antivirus_instance
    instance = success ? lambda {|f| 0 } : lambda {|f| 1 }
    Curate.configuration.default_antivirus_instance = instance
    yield
  ensure
    Curate.configuration.default_antivirus_instance = before_override
  end
end