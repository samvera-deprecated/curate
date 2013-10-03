require 'spec_helper'

describe Image do
  subject { Image.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:title) }
  it { should have_unique_field(:date_uploaded) }
  it { should have_unique_field(:date_modified) }
  it { should have_unique_field(:identifier) }
  it { should have_unique_field(:StateEdition) }
  it { should have_unique_field(:rights) }

  it { should have_multivalue_field(:location) }
  it { should have_multivalue_field(:category) }
  it { should have_multivalue_field(:measurements) }
  it { should have_multivalue_field(:material) }
  it { should have_multivalue_field(:source) }
  it { should have_multivalue_field(:inscription) }
  it { should have_multivalue_field(:textref) }
  it { should have_multivalue_field(:cultural_context) }
  it { should have_multivalue_field(:style_period) }
  it { should have_multivalue_field(:technique) }

  it { should have_multivalue_field(:creator) }
  it { should have_multivalue_field(:subject) }
  it { should have_multivalue_field(:publisher) }
  it { should have_multivalue_field(:description) }
  it { should have_multivalue_field(:date_created) }
end
