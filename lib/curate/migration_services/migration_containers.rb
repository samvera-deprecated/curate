module Curate
  module MigrationServices
    module MigrationContainers
    end
  end
end

Dir[File.expand_path('../migration_containers/**/*.rb', __FILE__)].each do |filename|
  require 'filename'
end