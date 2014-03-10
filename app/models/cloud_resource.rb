require 'HTTParty'
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

    attr_reader :downloaded_content_path

    attr_reader :authorize_key

    def authorize_key
      return nil if auth_header.nil?
      return CGI::unescape(auth_header["Authorization"])
    end

    def file
      'file'
    end

    def web
      'http' || 'https'
    end

    def assign_headers
      return {} if authorize_key.nil?
      return {:headers => {"Authorization"=>authorize_key}}
    end

    def download_content_from_host
      uri=URI.parse(download_url)
      case uri.scheme
        when 'http', 'https'
          logger.debug("Header:#{assign_headers.inspect}")
          response = HTTParty.get(download_url,assign_headers )
          logger.debug("Code from url:#{response.code}, URL:#{download_url}")
          if response.code == 200
            extn=MIME::Types[response.content_type].first.extensions.first
            @downloaded_content_path = Rails.root.to_s + "/tmp/" +uri.path.split("/").last+".#{extn}"
            logger.debug("Writing to #{@downloaded_content_path.inspect}")
            File.open(@downloaded_content_path, "wb"){|f| f.write(response.parsed_response)}
          end
        when file
          temp=File.new(uri.path)
          @downloaded_content_path=Rails.root.to_s + "/tmp/" +uri.path.split("/").last
          File.open(@downloaded_content_path, "w"){|f| f.write(temp.read)} if File.exists?(temp)
          temp.close
        else
          @downloaded_content_path=nil
         logger.error("Unknown provider")
      end
      logger.debug("Downloaded to path:#{@downloaded_content_path.inspect}")
      downloaded_content_path
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
