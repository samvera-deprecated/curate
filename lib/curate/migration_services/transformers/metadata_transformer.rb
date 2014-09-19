module Curate
  module MigrationServices
    module Transformers
      module MetadataTransformer
        module_function
        def call(content_model_name, pid, content)
          transformer_name = "#{content_model_name}Model"
          transformer_class =
          if const_defined?(transformer_name)
            const_get(transformer_name)
          else
            BaseModel
          end
          transformer_class.new(content_model_name, pid, content).call
        end

        class BaseModel
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

          def simple_predicate_map
            []
          end

          def transform(line)
            returning_line = remap_term_predicates(line)
            returning_line = transform_pid_to_name(returning_line)
            returning_line
          end

          def remap_term_predicates(line)
            simple_predicate_map.each_with_object(line) do |(from, to), mem|
              mem.sub!(from, to)
              mem
            end
          end

          def transform_pid_to_name(line)
            prefix = "<info:fedora/#{pid}> <http://purl.org/dc/terms/creator>"
            regexp = /^#{Regexp.escape(prefix)} \<info:fedora\/([^\>]*)\> \.$/
            regexp =~ line
            person_pid = $1
            return line unless person_pid

            name = extract_name_for(person_pid)
            transform_creator_triple_for(prefix, name)
          end

          def extract_name_for(person_pid)
            person = ::Person.find(person_pid)
            name = ""
            if person.name.present?
              name = person.name
            elsif user = ::User.where(repository_id: person_pid).first
              name = user.name
            else
              name = user.user_key
            end
          end

          def transform_creator_triple_for(prefix, name)
            if name.present?
              return "#{prefix.sub(/\/creator/, '/contributor')} \"#{name}\" ."
            else
              return nil
            end
          end
        end

        class ImageModel < BaseModel
          def transform_creator_triple_for(prefix, name)
            if name.present?
              return "#{prefix} \"#{name}\" ."
            else
              return nil
            end
          end
        end

        class ArticleModel < BaseModel
          def simple_predicate_map
            [
              ['<http://purl.org/dc/terms/title#alternate>', '<http://purl.org/dc/terms/alternative>'],
              ['<http://purl.org/dc/terms/contributor>', '<http://purl.org/dc/terms/contributor#author>'],
              ['<http://purl.org/dc/terms/description#abstract>', '<http://purl.org/dc/terms/abstract>'],
              ['<http://purl.org/dc/terms/date#created>', '<http://purl.org/dc/terms/created>'],
              ['<http://purl.org/dc/terms/coverage#temporal>', '<http://purl.org/dc/terms/temporal>'],
              ['<http://purl.org/dc/terms/coverage#spatial>', '<http://purl.org/dc/terms/spatial>'],
              ['<http://purl.org/dc/terms/rights#permission>', '<http://purl.org/dc/terms/rights#permissions>'],
            ]
          end

          def transform_creator_triple_for(prefix, name)
            if name.present?
              return "#{prefix.sub(/\/creator/, '/creator#author')} \"#{name}\" ."
            else
              return nil
            end
          end
        end
        class DatasetModel < BaseModel
          def simple_predicate_map
            [
              ['<http://purl.org/dc/terms/contributor>', '<http://purl.org/dc/terms/contributor#author>'],
              ['<http://purl.org/dc/terms/date#created>', '<http://purl.org/dc/terms/created>'],
            ]
          end

          def transform_creator_triple_for(prefix, name)
            if name.present?
              return "#{prefix.sub(/\/creator/, '/creator#author')} \"#{name}\" ."
            else
              return nil
            end
          end
        end
        class DocumentModel < BaseModel
          def simple_predicate_map
            [
              ['<http://purl.org/dc/terms/contributor>', '<http://purl.org/dc/terms/contributor#author>'],
              ['<http://purl.org/dc/terms/description>', '<http://purl.org/dc/terms/abstract>'],
              ['<http://purl.org/dc/terms/date#created>', '<http://purl.org/dc/terms/created>'],
            ]
          end

          def transform_creator_triple_for(prefix, name)
            if name.present?
              return "#{prefix.sub(/\/creator/, '/creator#author')} \"#{name}\" ."
            else
              return nil
            end
          end
        end
      end
    end
  end
end
