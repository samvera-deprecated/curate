require 'spec_helper'

describe ClassifyConcern do
  subject { ClassifyConcern.new(curation_concern_type: curation_concern_type) }
  let(:curation_concern_type) { nil }

  describe 'with curation_concern_type: nil' do
    it 'is not valid' do
      expect(subject).to_not be_valid
    end

    it 'raises an error on .curation_concern_class' do
      expect{
        subject.curation_concern_class
      }.to raise_error(RuntimeError)
    end
  end

  describe 'with curation_concern_type: "SeniorThesis"' do
    let(:curation_concern_type) { "SeniorThesis" }

    it 'is valid if curation_concern_type is from the right list' do
      expect(subject).to be_valid
    end

    it 'has a <SeniorThesis> class for curation_concern_class' do
      expect(subject.curation_concern_class).to eq(SeniorThesis)
    end
  end
end
