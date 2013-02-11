class DigitalObjectIdentifier

=begin
  def initialize(target, creator, title, publisher, publicationyear)
    @target = target
    @creator = creator
    @title = title
    @publisher = publisher
    @publicationyear = publicationyear
  end
=end
  attr_accessor :target, :creator, :title, :publisher, :publicationyear

  def data
    "_target: #{@target}\ndatacite.creator: #{@creator}\ndatacite.title: #{@title}\ndatacite.publisher: #{@publisher}\ndatacite.publicationyear: #{@publicationyear}\n"
  end

  def create_doi
    response = RestClient.post DoiConfig.url, data, :content_type => 'text/plain'
    return response
  end
end

