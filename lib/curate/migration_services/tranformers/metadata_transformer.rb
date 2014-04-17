module Curate
  module MigrationServices
    module Transformers
      class MetadataTransformer
        def self.call(content_model_name, pid, content)
          new(content_model_name, pid, content).call
        end

        attr_reader :content_model_name, :pid, :content
        def initialize(content_model_name, pid, content)
          @content_model_name = content_model_name
          @pid = pid
          @content = content
        end

        def call
          content.split("\n").collect do |line|
            transform(line)
          end.flatten.compact.join("\n")
        end

        private

        def transform(line)
          returning_line = remap_term_predicates(line)
          returning_line = transform_pid_to_person(returning_line)
          returning_line
        end

        def remap_term_predicates(line)
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

        def transform_pid_to_person(line)
          prefix = "<info:fedora/#{pid}> <http://purl.org/dc/terms/creator>"
          regexp = /^#{Regexp.escape(prefix)} \<info:fedora\/([^\>]*)\> \.$/
          regexp =~ line
          person_pid = $1
          return line unless person_pid

          name = extract_name_for(person_pid)
          transform_triple_for(prefix, name)
        end

        def extract_name_for(person_pid)
          person = ::Person.find(person_pid)
          name = ""
          if person.name.present?
            name = person.name
          elsif user = ::User.where(repository_id: person_pid).first
            name = user.name
          else
            name = user.email
          end
        end

        def transform_triple_for(prefix, name)
          if name.present?
            return "#{prefix} \"#{name}\" ."
          else
            return nil
          end
        end
      end
    end
  end
end
