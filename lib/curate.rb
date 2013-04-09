require "curate/engine"
require 'rails'
require 'sufia'

%w(helpers validators repository_models repository_datastreams workers).each do |slug|
  directory = File.expand_path("../app/#{slug}",File.dirname(__FILE__))
  Dir.glob(File.join(directory, '**/*.rb')).each do |filename|
    require filename
  end
end


module Curate
end
