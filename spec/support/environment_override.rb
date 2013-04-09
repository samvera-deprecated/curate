module EnvironmentOverride
  module_function
  def with_anti_virus_scanner(success = true)
    if ! Rails.configuration.respond_to?(:default_antivirus_instance)
      raise RuntimeError, "Undefined Rails.configuration.default_antivirus_instance"
    end
    before_override = Rails.configuration.default_antivirus_instance

    instance = success ? lambda {|f| 0 } : lambda {|f| 1 }
    Rails.configuration.default_antivirus_instance = instance
    yield
  ensure
    if Rails.configuration.respond_to?(:default_antivirus_instance)
      Rails.configuration.default_antivirus_instance = before_override
    end
  end
end