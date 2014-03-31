require 'spec_helper'

describe Person do

  describe 'associated with a user' do
    subject { FactoryGirl.create(:person_with_user) }
    its(:user) { should be_instance_of User }
    it '#profile' do
      expect(subject.profile).to be_instance_of Profile
      expect(subject.profile.depositor).to eq subject.user.to_s
      expect(subject.profile.title).to_not be_nil
      expect(subject.profile.read_groups).to eq [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
    end
  end

  describe 'not associated with a user' do
    subject { FactoryGirl.create(:person) }
    its(:user) { should be_nil }
  end

  describe 'Collection' do
    it 'should not add a person object to the collection' do
      person = Person.new
      expect(person.can_be_member_of_collection?(double)).to be_false
    end
  end

  describe 'Work' do
    let(:person) { FactoryGirl.create(:person_with_user) }
    let(:another_person) { FactoryGirl.create(:person_with_user) }
    let(:work) { FactoryGirl.create(:generic_work, user: person.user) }
    let(:collection) { FactoryGirl.create(:collection) }
    describe '#add_work' do
      it 'should add work' do
        person.works.should == []
        work.reload.edit_users.should == [person.depositor]

        person.add_work(work)
        another_person.add_work(work)

        person.reload.works.should == [work]
        work.reload.edit_users.should == [person.depositor, another_person.depositor]
      end

      it 'should not add non-work objects' do
        person.works.should == []
        person.add_work(collection)
        person.reload.works.should == []
      end
    end

    describe '#remove_work' do
      it 'should remove work' do
        another_person.works.should == []

        another_person.add_work(work)

        reload_another_person = Person.find(another_person.pid)
        another_person = reload_another_person

        another_person.works.should == [work]
        work.reload.edit_users.should include(another_person.depositor)

        another_person.remove_work(work)

        another_person.reload.works.should == []
        work.reload.edit_users.should_not include(another_person.depositor)
      end
    end
  end

  describe 'to_solr' do
    before do
      subject.name = "Aura D. Stanton"
    end
    let(:solr_doc) {subject.to_solr}

    it "should have a generic_type and name" do
      solr_doc['generic_type_sim'].should == ['Person']
      solr_doc['desc_metadata__name_tesim'].should == ["Aura D. Stanton"]
    end

    it 'has human_readable_type' do
      solr_doc['human_readable_type_sim'].should == 'Person'
    end
    it "is_user_ssi should be false" do
      solr_doc['has_user_bsi'].should be_false
    end

    describe "when the person has an associated user account" do
      before do
        subject.save
        FactoryGirl.create(:user, repository_id: subject.pid)
      end
      it "is_user_ssi should be true" do
        solr_doc['has_user_bsi'].should be_true
      end
    end
  end

end
