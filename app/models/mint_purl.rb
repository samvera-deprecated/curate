require 'method_decorators/precondition'
class MintPurl
  extend MethodDecorators

  class PurlError < RuntimeError
    def initialize(error_message)
      super(error_message)
    end
  end

  attr_reader :fedora_object

  +MethodDecorators::Precondition.new {|fedora_object| fedora_object.present? }
  def initialize(fedora_object)
    @fedora_object = fedora_object
  end

  def create_or_retreive_purl
    repo_object = RepoObject.where(:filename => fedora_object.to_param).first
    if repo_object
      purl = Purl.where(:repo_object_id => repo_object.repo_object_id).first
      return purl_url(purl.purl_id)
    end

    Purl.transaction do
      @repo_object = RepoObject.create_from_fedora_object(fedora_object)
      @purl = Purl.create_from_repo_object(@repo_object)
    end
    return purl_url(@purl.purl_id) if @purl
  rescue => e
    raise PurlError.new("Could not create Purl for the following reasons: #{e.backtrace.inspect}")
  end

  private

  def purl_url(purl_id)
    File.join(PurlConfig.url, purl_id.to_s, fedora_object.to_param)
  end

end
