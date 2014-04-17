require 'spec_helper'

describe Article do

  subject { Article.new }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'

  it { should have_unique_field(:human_readable_type) }
  it { should have_unique_field(:abstract) }
  it { should have_unique_field(:title) }
  it { should have_unique_field(:date_uploaded) }
  it { should have_unique_field(:date_modified) }
  it { should have_unique_field(:doi) }

  it { should have_multivalue_field(:source) }
  it { should have_multivalue_field(:issn) }
  it { should have_multivalue_field(:contributor) }
  it { should have_multivalue_field(:subject) }
  it { should have_multivalue_field(:publisher) }
  it { should have_multivalue_field(:language) }
  it { should have_multivalue_field(:requires) }
  it { should have_multivalue_field(:recommended_citation) }

  describe 'to_solr' do
    it 'derives dates from date_created fields' do
      date_string = '2010-4-5'
      art = FactoryGirl.build(:article, date_created: date_string)
      solr_doc = art.to_solr
      solr_doc['desc_metadata__date_created_tesim'].should == [date_string]
      expected_date = Date.parse(date_string)
      solr_doc['date_created_derived_dtsim'].first.to_date.should == expected_date
    end
  end

  describe 'related_works' do
    subject { FactoryGirl.create(
      :article,
      title: 'One Scholarly Paper',
      abstract:'This paper is really important. That is why I put it in the repository.'
    )}

    it_behaves_like 'with_related_works'
  end
end
