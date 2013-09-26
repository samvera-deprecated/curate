require 'spec_helper'

describe GenericWork do
  subject { GenericWork.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:available) }
  it { should have_unique_field(:archived_object_type) }

  context '#rights' do
    it 'has a default value' do
      subject.rights.should == 'All rights reserved'
    end
  end

end
