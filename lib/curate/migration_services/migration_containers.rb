module Curate
  module MigrationServices
    module MigrationContainers
    end
  end
end

require 'curate/migration_services/base_migrator'
Dir[File.expand_path('../migration_containers/**/*.rb', __FILE__)].each do |filename|
  require filename
end