require 'spec_helper'

describe QuickClassificationQuery do
  let(:normalizer) { lambda {|name| name.to_s.classify } }
  let(:registered_curation_concern_names) { ['Dataset'] }
  let(:curation_concern_names_to_try) { ['GenericWork', 'Dataset', 'Object'] }

  subject { described_class.new(query_context, options) }
  let(:options) {
    {
      concern_name_normalizer: normalizer,
      registered_curation_concern_names: registered_curation_concern_names,
      curation_concern_names_to_try: curation_concern_names_to_try
    }
  }
  let(:query_context) { User.new.tap { |u| u.stub(groups: ['registered']) } }

  context '#all' do
    its(:all) { should == [Dataset] }
  end

  context '.each_for_context' do
    it 'should yield' do
      expect {|b|
        described_class.each_for_context(query_context, options, &b)
      }.to yield_successive_args(Dataset)
    end
  end
end
