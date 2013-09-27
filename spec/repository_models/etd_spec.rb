require 'spec_helper'

describe Etd do
  subject { Etd.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:resource_type) }
  it { should have_unique_field(:abstract) }
  it { should have_unique_field(:title) }
  it { should have_unique_field(:date_uploaded) }
  it { should have_unique_field(:date_modified) }
  it { should have_unique_field(:identifier) }

  it { should have_multivalue_field(:contributor) }
  it { should have_multivalue_field(:creator) }
  it { should have_multivalue_field(:subject) }
  it { should have_multivalue_field(:publisher) }
  it { should have_multivalue_field(:language) }
end
