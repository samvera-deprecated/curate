class CloudResource
  class DownloadResource
    attr_reader :download_url, :auth_header, :expiration
    def initialize(specification)
      puts "Processing Specification:#{specification.inspect}"
      @download_url = specification[url_key.to_sym] || specification[url_key.to_s]
      @auth_header  = specification[header_key.to_sym] || specification[header_key.to_s]
      @expiration   = specification[expire_key.to_sym] || specification[expire_key.to_s]
    end

    def url_key
      :url
    end

    def header_key
      :auth_header
    end

    def expire_key
      :expires
    end
  end
  attr_reader :curation_concern, :user, :resources_to_ingest
  def initialize(curation_concern, user, params)
    @curation_concern = curation_concern
    @user = user
    @param_value = params[param_key.to_sym] || params[param_key.to_s]
    @resources_to_ingest=process_cloud_resource
  end

  def param_key
    :selected_files
  end
  attr_reader :param_value

  def process_cloud_resource
    return nil if param_value.nil?
    puts "need to process param_value:#{param_value.inspect}"
    param_value.collect{|index,resource| DownloadResource.new(resource)}
  end

end
