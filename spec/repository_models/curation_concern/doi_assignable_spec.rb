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
    let(:doi_remote_service) { double(accessor_name: accessor_name) }
    before(:each) do
      subject.doi_remote_service = doi_remote_service
    end

    context 'with explicit identifier specified' do
      let(:doi_assignment_strategy) { 'abc' }

      it 'should allow explicit assignment of identifer' do
        expect {
          subject.doi_assignment_strategy = doi_assignment_strategy
        }.to change(subject, :identifier).from(nil).to('abc')
      end
    end

    context 'with not now specified' do
      let(:doi_assignment_strategy) { subject.not_now_value_for_doi_assignment }

      it 'should allow explicit assignment of identifer' do
        expect {
          subject.doi_assignment_strategy = doi_assignment_strategy
        }.to_not change(subject, :identifier).from(nil)
      end
    end

    context 'with request for minting' do
      let(:doi_assignment_strategy) { accessor_name }

      it 'should request a minting' do
        subject.doi_remote_service = doi_remote_service
        doi_remote_service.should_receive(:mint).with(subject).and_return(true)
        expect {
          subject.doi_assignment_strategy = doi_assignment_strategy
        }.to_not change(subject, :identifier).from(nil)
      end
    end
  end
end