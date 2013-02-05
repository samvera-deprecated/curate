class DoiConfig
	@@config_info, @@url = nil
	def self.configure
		@@config_info ||= YAML.load(File.open(File.join(Rails.root, "config/doi.yml")))
	rescue => e
		puts "Configuration Error: #{e.message}"
		puts e.backtrace
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

#		username = 'apitest'
#		password = 'apitest'
#		shoulder = "doi:10.5072/FK2"; #Test Prefix
#   @mintURL = "https://#{username}:#{password}@n2t.net/ezid/shoulder/#{shoulder}";
	def self.url
		@@url ||= configure[Rails.env]['url'].sub("://", "://#{username}:#{password}@") + shoulder
	end
end
