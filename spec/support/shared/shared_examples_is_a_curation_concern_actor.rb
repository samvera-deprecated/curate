shared_examples 'is_a_curation_concern_actor' do |curation_concern_class|
  CurationConcern::FactoryHelpers.load_factories_for(self, curation_concern_class)
  include ActionDispatch::TestProcess
  let(:user) { FactoryGirl.create(:user) }
  let(:file) { fixture_file_upload('/files/image.png', 'image/png') }

  subject {
    CurationConcern.actor(curation_concern, user, attributes)
  }

  describe '#create' do

    let(:curation_concern) { curation_concern_class.new(pid: CurationConcern.mint_a_pid )}

    describe 'valid attributes' do
      let(:visibility) { Sufia::Models::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }

      describe 'with a file' do
        let(:attributes) {
          FactoryGirl.attributes_for(default_work_factory_name, visibility: visibility).tap {|a|
            a[:files] = file
          }
        }
        before(:each) do
          subject.create!
        end

        describe 'authenticated visibility' do
          it 'should stamp each file with the access rights' do
            expect(curation_concern).to be_persisted
            expect(curation_concern.date_uploaded).to eq Date.today
            expect(curation_concern.date_modified).to eq Date.today
            expect(curation_concern.depositor).to eq user.user_key

            expect(curation_concern.generic_files.count).to eq 1
            # Sanity test to make sure the file we uploaded is stored and has same permission as parent.
            generic_file = curation_concern.generic_files.first
            expect(generic_file.content.content).to eq file.read
            expect(generic_file.filename).to eq 'image.png'

            expect(curation_concern).to be_authenticated_only_access
            expect(generic_file).to be_authenticated_only_access
          end
        end
      end

      describe 'with a linked resource' do
        let(:attributes) {
          FactoryGirl.attributes_for(default_work_factory_name, visibility: visibility, linked_resource_url: 'http://www.youtube.com/watch?v=oHg5SJYRHA0')
        }
        before(:each) do
          subject.create!
        end

        describe 'authenticated visibility' do
          it 'should stamp each link with the access rights' do
            expect(curation_concern).to be_persisted
            expect(curation_concern.date_uploaded).to eq Date.today
            expect(curation_concern.date_modified).to eq Date.today
            expect(curation_concern.depositor).to eq user.user_key

            expect(curation_concern.generic_files.count).to eq 0
            expect(curation_concern.linked_resources.count).to eq 1
            # Sanity test to make sure the file we uploaded is stored and has same permission as parent.
            link = curation_concern.linked_resources.first
            expect(link.url).to eq 'http://www.youtube.com/watch?v=oHg5SJYRHA0'
            expect(curation_concern).to be_authenticated_only_access
          end
        end
      end
    end

    describe '#update' do
      let(:curation_concern) { FactoryGirl.create(default_work_factory_name, user: user)}
      describe 'adding to collections' do
        let!(:collection1) { FactoryGirl.create(:collection, user: user) }
        let!(:collection2) { FactoryGirl.create(:collection, user: user) }
        let(:attributes) {
          FactoryGirl.attributes_for(public_work_factory_name, collection_ids: [collection2.pid])
        }
        before do
          curation_concern
          # curation_concern.apply_depositor_metadata(user.user_key)
          # curation_concern.save!
          collection1.members << curation_concern
          collection1.save
        end
        it "should add to collections" do
          expect(curation_concern.collections).to eq [collection1]
          subject.update!
          expect(curation_concern.identifier).to be_blank
          expect(curation_concern).to be_persisted
          expect(curation_concern).to be_open_access
          expect(curation_concern.collections).to eq [collection2]
          expect(subject.visibility_changed?).to be_true
        end
      end
    end
  end
end