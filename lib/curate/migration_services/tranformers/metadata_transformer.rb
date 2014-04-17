module Curate
  module MigrationServices
    module Transformers
      module MetadataTransformer
        module_function
        def call(pid, content)
          content.split("\n").collect do |line|
            transform(pid, line)
          end.flatten.compact.join("\n")
        end

        def transform(pid, line)
          returning_line = remap_term_predicates(pid, line)
          returning_line = transform_pid_to_person(pid, returning_line)
          returning_line
        end

        def remap_term_predicates(pid, line)
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

        def transform_pid_to_person(pid, line)
          prefix = "<info:fedora/#{pid}> <http://purl.org/dc/terms/creator>"
          regexp = /^#{Regexp.escape(prefix)} \<info:fedora\/([^\>]*)\> \.$/
          regexp =~ line
          person_pid = $1
          if person_pid
            person = ::Person.find(person_pid)
            name = ""
            if person.name.present?
              name = person.name
            elsif user = ::User.where(repository_id: person_pid).first
              name = user.name
            else
              name = user.email
            end
            if name.present?
              "#{prefix} \"#{name}\" ."
            else
              nil
            end
          else
            line
          end
          line
        end
      end
    end
  end
end
