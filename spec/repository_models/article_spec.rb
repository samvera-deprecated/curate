require 'spec_helper'

describe Article do
  subject { Article.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:archived_object_type) }
  it { should have_unique_field(:abstract) }
  it { should have_unique_field(:title) }
  it { should have_unique_field(:journal_information) }
  it { should have_unique_field(:date_uploaded) }
  it { should have_unique_field(:date_modified) }
  it { should have_unique_field(:date_digitized) }
  it { should have_unique_field(:identifier) }
  it { should have_unique_field(:issn) }

  it { should have_multivalue_field(:contributor) }
  it { should have_multivalue_field(:creator) }
  it { should have_multivalue_field(:subject) }
  it { should have_multivalue_field(:publisher) }
  it { should have_multivalue_field(:language) }
  it { should have_multivalue_field(:requires) }
  it { should have_multivalue_field(:recommended_citation) }
end
