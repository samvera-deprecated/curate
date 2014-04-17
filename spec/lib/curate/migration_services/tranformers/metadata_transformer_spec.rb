require File.expand_path('../../../../../../lib/curate/migration_services/tranformers/metadata_transformer', __FILE__)
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
      let(:expected_output) {
        [
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/created> "2014-04-15" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/dateSubmitted> "2014-04-15Z"^^<http://www.w3.org/2001/XMLSchema#date> .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/title> "The Title" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/alternative> "The Alternate Title" .),
          %(<info:fedora/#{pid}> <http://purl.org/dc/terms/creator> "#{person.name}" .),
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
      let(:output) { described_class.call(pid, content) }

      it 'should convert as expected' do
        expect(output).to eq(expected_output)
      end

      it 'should convert :contributor predicate to :contributor#author'

      it 'should convert :title#alternate predicate to :alternative' do
        expect(output).to_not include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/title#alternate> "The Alternate Title" .))
        expect(output).to include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/alternative> "The Alternate Title" .))
      end

      it 'should convert :description#abstract predicate to :abstract' do
        expect(output).to_not include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/description#abstract> "The Abstract" .))
        expect(output).to include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/abstract> "The Abstract" .))
      end

      it 'should convert :date#created predicate to :created' do
        expect(output).to_not include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/date#created> "2014-04-15" .))
        expect(output).to include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/created> "2014-04-15" .))
      end

      it 'should convert :coverage#temporal predicate to :temporal' do
        expect(output).to_not include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/coverage#temporal> "Somewhen" .))
        expect(output).to include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/temporal> "Somewhen" .))
      end

      it 'should convert :coverage#spatial predicate to :spatial' do
        expect(output).to_not include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/coverage#spatial> "Somewhere" .))
        expect(output).to include(%(<info:fedora/#{pid}> <http://purl.org/dc/terms/spatial> "Somewhere" .))
      end

    end
  end
end
