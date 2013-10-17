require 'spec_helper'

describe ClassifyConcern do
  subject { ClassifyConcern.new(curation_concern_type: curation_concern_type) }
  let(:curation_concern_type) { nil }
  before(:each) do
    subject.registered_curation_concern_types = ['GenericWork']
  end
  its(:all_curation_concern_classes) { should include(GenericWork)}
  its(:all_curation_concern_classes) { should_not include('GenericWork')}

  describe 'with curation_concern_type: nil' do
    it { should_not be_valid}
    it 'raises an error on .curation_concern_class' do
      expect{
        subject.curation_concern_class
      }.to raise_error(RuntimeError)
    end
  end

  describe 'with curation_concern_type: "GenericWork"' do
    let(:curation_concern_type) { "GenericWork" }
    it { should be_valid}
    its(:curation_concern_class) { should eq(GenericWork) }
  end

  describe '#upcoming_concerns' do
    it 'yields two elements' do
      expect(subject.upcoming_concerns).to be_kind_of(Array)
    end
  end

  describe '.normalize_concern_name' do
    it { expect(described_class.normalize_concern_name(:generic_file)).to eq('GenericFile') }
  end
end
