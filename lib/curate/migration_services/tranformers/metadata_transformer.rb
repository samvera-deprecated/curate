module Curate
  module MigrationServices
    module Transformers
      module MetadataTransformer
        module_function
        def call(pid, content)
          content.split("\n").collect do |line|
            transform(line)
          end.flatten.compact.join("\n")
        end

        def transform(line)
          [
            ['<http://purl.org/dc/terms/title#alternate>', '<http://purl.org/dc/terms/alternative>'],
            ['<http://purl.org/dc/terms/description#abstract>', '<http://purl.org/dc/terms/abstract>'],
            ['<http://purl.org/dc/terms/date#created>', '<http://purl.org/dc/terms/created>'],
            ['<http://purl.org/dc/terms/coverage#temporal>', '<http://purl.org/dc/terms/temporal>'],
            ['<http://purl.org/dc/terms/coverage#spatial>', '<http://purl.org/dc/terms/spatial>'],
          ].each_with_object(line) do |(from, to), mem|
            mem.sub!(from, to)
            mem
          end
        end
      end
    end
  end
end
