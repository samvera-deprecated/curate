require File.expand_path('../../../../../../lib/curate/migration_services/transformers/metadata_transformer', __FILE__)
require 'spec_helper'

module Curate::MigrationServices::Transformers
  describe MetadataTransformer do
    context '.call' do
      subject { described_class }
      let(:pid) { "und:ft8491830" }
      let(:person) { FactoryGirl.create(:person, name: "Dr. Who")}
      let(:content) {
        [
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/date#created> "2014-04-15" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/dateSubmitted> "2014-04-15Z"^^<http://www.w3.org/2001/XMLSchema#date> .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/title> "The Title" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/title#alternate> "The Alternate Title" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/creator> <info:fedora/#{person.pid}> .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/contributor> "The Master" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/description#abstract> "The Abstract" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/subject> "The Subject" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/subject> "The Second Subject" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/publisher> "The Publisher" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/publisher> "The Second Publisher" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/bibliographicCitation> "The Citation" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/bibliographicCitation> "The Second Citation" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/language> "English" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/language> "Spanish" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/rights> "All rights reserved" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/coverage#spatial> "Somewhere" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/coverage#temporal> "Somewhen" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/modified> "2014-04-15Z"^^<http://www.w3.org/2001/XMLSchema#date> .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/identifier> "doi:1234" .),
          %()
        ].join("\n")
      }

      context 'Article model name' do
        let(:expected_output) {
          [
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/created> "2014-04-15" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/dateSubmitted> "2014-04-15Z"^^<http://www.w3.org/2001/XMLSchema#date> .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/title> "The Title" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/alternative> "The Alternate Title" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/creator#author> "#{person.name}" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/contributor#author> "The Master" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/abstract> "The Abstract" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/subject> "The Subject" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/subject> "The Second Subject" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/publisher> "The Publisher" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/publisher> "The Second Publisher" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/bibliographicCitation> "The Citation" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/bibliographicCitation> "The Second Citation" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/language> "English" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/language> "Spanish" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/rights> "All rights reserved" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/spatial> "Somewhere" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/temporal> "Somewhen" .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/modified> "2014-04-15Z"^^<http://www.w3.org/2001/XMLSchema#date> .),
            %(<info:fedora/#{pid}> <http://purl.org/dc/terms/identifier> "doi:1234" .),
          ].join("\n")
        }
        let(:output) { described_class.call('Article', pid, content) }

        it 'should convert as expected' do
          expect(output).to eq(expected_output)
        end
      end

    end
  end
end
