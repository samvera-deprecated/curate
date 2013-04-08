module EnvironmentOverride
  module_function
  def with_anti_virus_scanner(success = true)
    before_configuration_option = nil
    if Rails.configuration.respond_to?(:default_antivirus_instance)
      before_configuration_option = Rails.configuration.default_antivirus_instance
    end
    instance = success ? lambda {|f| 0 } : lambda {|f| 1 }
    Rails.configuration.default_antivirus_instance = instance
    yield
  ensure
    if before_configuration_option
      Rails.configuration.default_antivirus_instance = before_configuration_option
    end
  end
end