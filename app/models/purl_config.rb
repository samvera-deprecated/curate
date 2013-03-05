class PurlConfig
  @@config_info = nil
  def self.configure
    @@config_info ||= YAML.load(File.open(File.join(Rails.root, "config/purl.yml")))
  rescue => e
    raise e
  end

  def self.url
    configure[Rails.env]['url']
  end
end
