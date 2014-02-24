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

end
