require 'spec_helper'

describe GenericWork do
  subject { FactoryGirl.build(:generic_work) }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:available) }
  it { should have_unique_field(:resource_type) }

  context '#rights' do
    it 'has a default value' do
      GenericWork.new.rights.should == 'All rights reserved'
    end
  end

end
