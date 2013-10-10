require 'spec_helper'

describe Etd do
  subject { FactoryGirl.build(:etd) }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_common_solr_fields'
  it_behaves_like 'has_linked_creators'

  it { should have_unique_field(:resource_type) }
  it { should have_unique_field(:abstract) }
  it { should have_unique_field(:title) }
  it { should have_unique_field(:date_uploaded) }
  it { should have_unique_field(:date_modified) }
  it { should have_unique_field(:identifier) }

  it { should have_multivalue_field(:contributor) }
  it { should have_multivalue_field(:subject) }
  it { should have_multivalue_field(:publisher) }
  it { should have_multivalue_field(:language) }

  describe "without any creator" do
    it "should have an error" do
      subject.should_not be_valid
      subject.errors[:creators].should == ['Your thesis must have an author.']
    end
  end

  describe "with a couple of creators" do
    let(:creator1) { FactoryGirl.create(:person) }
    let(:creator2) { FactoryGirl.create(:person) }
    before { subject.creators << creator1 << creator2 }
    let(:solr_doc) { subject.to_solr }
    it "should index the creators names" do
      solr_doc['desc_metadata__creator_tesim'].should == [creator1.name, creator2.name]
    end
  end

end
