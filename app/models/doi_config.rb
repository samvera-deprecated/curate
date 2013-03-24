class DoiConfig
  @@config_info, @@url = nil
  def self.configure
    @@config_info ||= YAML.load(File.open(File.join(Rails.root, "config/doi.yml")))
  end

  def self.username
    configure[Rails.env]['username']
  end

  def self.password
    configure[Rails.env]['password']
  end

  def self.shoulder
    configure[Rails.env]['shoulder']
  end

  def self.url_for_creating_doi
    @@url_for_creating_doi ||= "#{configure[Rails.env]['url'].sub("://", "://#{username}:#{password}@")}shoulder/#{shoulder}"
  end

  def self.url_for_updating_doi
    @@url_for_updating_doi ||= "#{configure[Rails.env]['url'].sub("://", "://#{username}:#{password}@")}id/"
  end
end
