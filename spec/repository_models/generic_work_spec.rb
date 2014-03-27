require 'spec_helper'

describe GenericWork do
  subject { FactoryGirl.build(:generic_work) }

  it_behaves_like 'with_access_rights'
  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'
  it_behaves_like 'remotely_identified', :doi

  it { should have_unique_field(:available) }
  it { should have_unique_field(:human_readable_type) }

  context '#rights' do
    it 'has a default value' do
      GenericWork.new.rights.should == 'All rights reserved'
    end
  end

  context '#as_json' do
    it 'returns the human readable type' do
      subject.as_json({})[:curation_concern_type].should == subject.human_readable_type
    end
  end

  context 'Representative Image' do
    let!(:work) { FactoryGirl.create(:generic_work, title: 'Work') }
    it "shows up in the solr document" do
      work.to_solr["representative"].should == nil
      work.representative = "123"
      work.save
      work.to_solr["representative_tesim"].should == "123"
    end
  end

  context 'Embargo testing' do
    let!(:work) { FactoryGirl.create(:generic_work, title: 'Embargo Work') }
     
    it "should not be under embargo by default" do
      work.under_embargo?.should be_false
     end
    
    it "should be under embargo when embargo is set" do
      #set embargo to 1 day from now
      work.embargo_release_date = (Time.now + 1.day).strftime("%Y-%m-%e")
      work.save
      work.under_embargo?.should be_true
    end

    it "should successfully get released from embargo" do
      #set embargo to 1 day ago
      work.embargo_release_date = (Time.now - 1.day).strftime("%Y-%m-%e")
      work.save
      work.under_embargo?.should be_false
    end

  end

  describe 'Editor' do
    let(:person) { FactoryGirl.create(:person_with_user) }
    let(:another_person) { FactoryGirl.create(:person_with_user) }
    let(:work) { FactoryGirl.create(:generic_work, user: person.user) }
    let(:collection) { FactoryGirl.create(:collection) }
    describe '#add_editor' do
      it 'should add editor' do
        work.editors.should == []

        work.add_editor(person)
        work.add_editor(another_person)

        work.reload.editors.should == [person, another_person]
        work.reload.edit_users.should == [person.depositor, another_person.depositor]
      end

      it 'should not add non-work objects' do
        work.editors.should == []
        work.add_editor(collection)
        work.reload.editors.should == []
      end
    end

    describe '#remove_editor' do
      it 'should remove editor' do
        work.editors.should == []
        work.add_editor(another_person)

        reload_work = GenericWork.find(work.pid)
        work = reload_work

        work.editors.should == [another_person]
        work.edit_users.should include(another_person.depositor)

        work.remove_editor(another_person)

        reload_work = GenericWork.find(work.pid)
        work = reload_work

        work.editors.should == []
        work.edit_users.should_not include(another_person.depositor)
      end
    end
  end

  describe 'EditorGroup' do
    let(:person) { FactoryGirl.create(:person_with_user) }
    let(:user) { person.user }
    let(:group) { FactoryGirl.create(:group, user: user) }
    let(:work) { FactoryGirl.create(:generic_work, user: person.user) }
    let(:collection) { FactoryGirl.create(:collection) }
    describe '#add_editor_group' do
      it 'should add group' do
        work.editor_groups.should == []

        work.add_editor_group(group)

        reload_work = GenericWork.find(work.pid)
        work = reload_work

        work.editor_groups.should == [group]
        work.edit_groups.should == [group.title]
      end

      it 'should not add non-group objects' do
        work.editor_groups.should == []
        work.add_editor_group(collection)
        work.reload.editor_groups.should == []
      end
    end

    describe '#remove_editor_group' do
      it 'should remove editor_group' do
        work.editor_groups.should == []
        work.add_editor_group(group)

        reload_work = GenericWork.find(work.pid)
        work = reload_work

        work.editor_groups.should == [group]
        work.edit_groups.should include(group.title)

        work.remove_editor_group(group)

        reload_work = GenericWork.find(work.pid)
        work = reload_work

        work.editor_groups.should == []
        work.edit_groups.should_not include(group.title)
      end
    end
  end
end
