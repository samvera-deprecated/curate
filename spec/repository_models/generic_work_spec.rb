require 'spec_helper'

describe GenericWork do
  subject { GenericWork.new }

  include_examples 'with_access_rights'
  include_examples 'is_embargoable'
  include_examples 'has_dc_metadata'

  it { should have_unique_field(:available) }
  it { should have_unique_field(:archived_object_type) }

  context '#rights' do
    it 'has a default value' do
      subject.rights.should == 'All rights reserved'
    end
  end

end
