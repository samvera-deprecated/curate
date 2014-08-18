require 'spec_helper'

describe GenericWork do
  subject { FactoryGirl.build(:generic_work) }

  it_behaves_like 'with_related_works'
  it_behaves_like 'is_embargoable'
  it_behaves_like 'has_dc_metadata'
  it_behaves_like 'has_common_solr_fields'
  # it_behaves_like 'remotely_identified', :doi

  it { should have_unique_field(:available) }
  it { should have_unique_field(:human_readable_type) }

  context '#rights' do
    it 'has a default value' do
      GenericWork.new.rights.should == 'All rights reserved'
    end
  end

  context 'solrize doi' do
    let!(:work) { FactoryGirl.create(:generic_work, title: 'Work') }
    it 'should solrize doi' do
      work.to_solr.keys.should_not include('desc_metadata__identifier_tesim')
      work.identifier = 'doi:10.5072/FK2'
      work.save!
    
      work.to_solr.keys.should include('desc_metadata__identifier_tesim')
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
      work.save!
      work.to_solr["representative_tesim"].should == "123"
    end
  end

  describe 'Embargo' do
    let!(:work) { FactoryGirl.create(:generic_work, title: 'Embargo Work', visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO) }
     
    it "should not be under embargo by default" do
      expect(work).to_not be_under_embargo
    end
    
    it "should be under embargo when embargo is set" do
      #set embargo to 1 day from now
      work.embargo_release_date = (Time.now + 1.day).strftime("%Y-%m-%d")
      work.save!
      work.should be_under_embargo
    end

    it 'should not allow you to set a past date' do
      work.embargo_release_date = (Time.now - 1.day).strftime('%Y-%m-%d')
      expect(work).to be_invalid
      expect(work.errors[:embargo_release_date]).to eq ['Must be a future date']
    end

    it 'should successfully get released from embargo' do
      #set embargo to 1 day ago
      work.embargo_release_date = (Time.now - 1.day).strftime('%Y-%m-%d')
      work.save(validate: false)
      work.should_not be_under_embargo
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
        work.add_editor(person.user)
        work.add_editor(another_person.user)

        work.save!

        work.reload
        work.editors.should eq [person, another_person]
        work.edit_users.should eq [person.depositor, another_person.depositor]
      end

      it 'should not add non-work objects' do
        work.editors.should == []
        expect { work.add_editor(collection) }.to raise_error ArgumentError
        work.reload.editors.should == []
      end
    end

    describe '#remove_editor' do
      before do
        work.editors.should == []
        work.add_editor(another_person.user)
        work.save!
        work.reload
      end
      it 'should remove editor' do
        work.remove_editor(another_person.user)

        work.reload

        work.editors.should == []
        work.edit_users.should_not include(another_person.user.user_key)
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

        work.reload

        work.editor_groups.should == [group]
        work.edit_groups.should == [group.pid]
      end

      it 'should not add non-group objects' do
        expect { work.add_editor_group(collection) }.to raise_error ArgumentError
        work.reload.editor_groups.should == []
      end
    end

    describe '#remove_editor_group' do
      before do
        work.editor_groups.should == []
        work.add_editor_group(group)

        work.reload
      end

      it 'should remove editor_group' do
        work.remove_editor_group(group)

        work.reload

        work.editor_groups.should == []
        work.edit_groups.should_not include(group.pid)
      end

      it 'should delete relationship when related object is deleted' do
        group_pid = group.pid
        group.destroy

        work.reload

        work.editor_groups.should == []
        work.edit_groups.should_not include(group_pid)
        work.datastreams['RELS-EXT'].content.to_s.should_not include(group_pid)
      end
    end
  end
end

describe GenericWork do
  subject { GenericWork.new }

  it_behaves_like 'with_access_rights'

end
