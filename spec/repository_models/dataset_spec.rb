require 'spec_helper'

describe Dataset do
  subject {  FactoryGirl.build(:dataset) }

  it_behaves_like 'is_a_curation_concern_model'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'

end

describe Dataset do
  subject { Dataset.new }

  it_behaves_like 'with_access_rights'

end
