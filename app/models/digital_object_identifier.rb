class DigitalObjectIdentifier

  def initialize(target, creator, title, publisher, publicationyear)
    @target = target
    @creator = creator
    @title = title
    @publisher = publisher
    @publicationyear = publicationyear
  end

  attr_reader :target, :creator, :title, :publisher, :publicationyear

  def data
    "_target: #{@target}\ndatacite.creator: #{@creator}\ndatacite.title: #{@title}\ndatacite.publisher: #{@publisher}\ndatacite.publicationyear: #{@publicationyear}\n"
  end

  def create_doi
    response = RestClient.post DoiConfig.url, data, :content_type => 'text/plain'
    return response
  rescue => e
    puts e.message
    puts e.backtrace
    return e.message
  end
end

=begin
  DigitalObjectIdentifier.new("_target: https://fedorapprd.library.nd.edu:8443/fedora/get/RBSC-CURRENCY:671/", "datacite.creator: Comstock, Adam", "datacite.title: Notre Dame Currency Test", "datacite.publisher: University of Notre Dame - Libraries", "datacite.publicationyear: 2011")
=end
