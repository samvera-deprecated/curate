require 'spec_helper'

describe CurationConcern::DoiAssignable do
  around(:each) do |example|
    class DatastreamClass < ActiveFedora::NtriplesRDFDatastream
      map_predicates do |map|
        map.identifier({in: RDF::DC})
      end
    end
    example.run
    Object.send(:remove_const, :DatastreamClass)
  end

  let(:model) do
    Class.new(ActiveFedora::Base) do
      has_metadata "descMetadata", type: DatastreamClass
      include CurationConcern::DoiAssignable
    end
  end

  context '#doi_assignment_strategy' do
    subject { model.new }
    let(:accessor_name) { 'mint_doi' }
    let(:existing_identifier) { 'abc' }
    let(:doi_remote_service) { double(accessor_name: accessor_name) }
    before(:each) do
      subject.existing_identifier = existing_identifier
      subject.doi_assignment_strategy = doi_assignment_strategy
      subject.doi_remote_service = doi_remote_service
    end

    context 'with explicit identifier specified' do
      let(:doi_assignment_strategy) { described_class::ALREADY_GOT_ONE }

      it 'should allow explicit assignment of identifer' do
        expect {
          subject.send(:apply_doi_assignment_strategy)
        }.to change(subject, :identifier).from(nil).to(existing_identifier)
      end
    end

    context 'with not now specified' do
      let(:doi_assignment_strategy) { described_class::NOT_NOW }

      it 'should not update identifier' do
        expect {
          subject.send(:apply_doi_assignment_strategy)
        }.to_not change(subject, :identifier).from(nil)
      end
    end

    context 'with request for minting' do
      let(:doi_assignment_strategy) { accessor_name }

      it 'should update the remote service accessor so we can remotely mint the DOI' do
        subject.should_receive("#{accessor_name}=").with('1').and_return(true)
        doi_remote_service.should_receive(:registered?).with(subject).and_return(true)
        expect {
          subject.send(:apply_doi_assignment_strategy)
        }.to_not change(subject, :identifier).from(nil)
      end
    end
  end
end