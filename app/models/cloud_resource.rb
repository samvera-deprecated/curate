require 'httparty'
class CloudResource
  class DownloadResource
    attr_reader :download_url, :auth_header, :expiration, :file_name
    def initialize(specification)
      @download_url = specification[url_key.to_sym] || specification[url_key.to_s]
      @auth_header  = specification[header_key.to_sym] || specification[header_key.to_s]
      @expiration   = specification[expire_key.to_sym] || specification[expire_key.to_s]
      @file_name   = specification[filename.to_sym] || specification[filename.to_s]
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

    def filename
      :file_name
    end

    attr_reader :downloaded_content_path

    attr_reader :authorize_key

    def authorize_key
      return nil if auth_header.nil?
      return cgi_escape(auth_header["Authorization"])
    end

    def cgi_escape(string)
      CGI::unescape(string)
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

    def get_filename(uri)
      filename= file_name || uri.path.split("/").last
      cgi_escape(filename.gsub(File.extname(filename),""))
    end

    def download_content_from_host
      uri=URI.parse(download_url)
      case uri.scheme
        when 'http', 'https'
          response = HTTParty.get(download_url,assign_headers )
          if response.code == 200
            extn=MIME::Types[response.content_type].first.extensions.first
            @downloaded_content_path = Rails.root.to_s + "/tmp/" +get_filename(uri)+".#{extn}"
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
    param_value.collect{|index,resource| DownloadResource.new(resource)}
  end

end
