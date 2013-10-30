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

  describe 'to_solr' do
    it 'derives dates from date_created fields' do
      dates = ['2012-10-31', '3rd century BCE']
      image = FactoryGirl.create(:image, date_created: dates)
      solr_doc = image.to_solr

      solr_doc['desc_metadata__date_created_tesim'].length.should == 2
      solr_doc['desc_metadata__date_created_tesim'].should =~ dates

      solr_doc['date_created_derived_dtsim'].length.should == 1
      expected_date = Date.parse('2012-10-31')
      solr_doc['date_created_derived_dtsim'].first.to_date.should == expected_date
    end
  end

  describe 'related_works' do
    subject { FactoryGirl.create(
      :image,
      title: 'My Fancy Photo',
      description:'I really like this picture I took. That is why I put it in the repository.'
    )}

    it_behaves_like 'with_related_works'
  end
end
