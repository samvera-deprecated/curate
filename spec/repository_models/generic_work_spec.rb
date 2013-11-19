require 'spec_helper'

describe GenericWork do
  subject { FactoryGirl.build(:generic_work) }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'
  it_behaves_like 'remotely_identified', :doi

  it { should have_unique_field(:available) }
  it { should have_unique_field(:human_readable_type) }

  context '#rights' do
    it 'has a default value' do
      GenericWork.new.rights.should == 'All rights reserved'
    end
  end

  context '#as_json' do
    it 'returns the human readable type' do
      subject.as_json({})[:curation_concern_type].should == subject.human_readable_type
    end
  end

  context 'Representative Image' do
    let!(:work) { FactoryGirl.create(:generic_work, title: 'Work') }
    it "shows up in the solr document" do
      work.to_solr["representative"].should == nil
      work.representative = "123"
      work.save
      work.to_solr["representative_tesim"].should == "123"
    end
  end

end
