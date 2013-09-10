require 'spec_helper'

describe Dataset do
  subject { Dataset.new }

  include_examples 'is_a_curation_concern_model'
  include_examples 'with_access_rights'
  include_examples 'with_related_works'
  include_examples 'is_embargoable'
  include_examples 'has_dc_metadata'

  it { should have_unique_field(:available) }

end
