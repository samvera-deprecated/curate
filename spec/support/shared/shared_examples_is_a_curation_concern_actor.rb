shared_examples 'is_a_curation_concern_actor' do |curation_concern_class, curation_concern_actor_options = {}|
  let(:with_contributors?) { !curation_concern_actor_options.fetch(:without_contributors, false) }
  let(:with_linked_resources?) { !curation_concern_actor_options.fetch(:without_linked_resources, false) }

  CurationConcern::FactoryHelpers.load_factories_for(self, curation_concern_class)
  include ActionDispatch::TestProcess
  let(:user) { FactoryGirl.create(:user) }
  let(:file) { curate_fixture_file_upload('/files/image.png', 'image/png') }


  let(:person) { FactoryGirl.create(:person) }

  subject {
    CurationConcern.actor(curation_concern, user, attributes)
  }

  describe '#create' do
    let(:contributors) { ["Mark Twain"] }
    let(:curation_concern) { curation_concern_class.new(pid: CurationConcern.mint_a_pid )}

    context 'valid attributes' do

      let(:attributes) {
        FactoryGirl.attributes_for(
          default_work_factory_name,
          files: [file]
        ).tap {|attrs|
          if with_contributors?
            attrs[:contributor] = contributors
          end
          if with_linked_resources?
            attrs[:linked_resource_urls] = 'http://www.youtube.com/watch?v=oHg5SJYRHA0'
          end
        }
      }

      it 'should be successful in updating attributes' do
        expect(subject.create).to eq(true)

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

        if with_contributors?
          expect(curation_concern.contributor).to eq(contributors)
        end

        if with_linked_resources?
          link = curation_concern.linked_resources.first
          expect(link.url).to eq 'http://www.youtube.com/watch?v=oHg5SJYRHA0'
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
          collection1.members << curation_concern
          collection1.save
        end
        it "should add to collections" do
          collection1.save # Had to call .save again to make this persist properly!? - MZ Sept 2013
          expect(curation_concern.collections).to eq [collection1]
          subject.update.should be_truthy

          reloaded_cc = curation_concern.class.find(curation_concern.pid)
          expect(reloaded_cc.identifier).to be_blank
          expect(reloaded_cc).to be_persisted
          expect(reloaded_cc).to be_open_access
          expect(reloaded_cc.collections).to eq [collection2]
          expect(subject.visibility_changed?).to be_truthy
        end
      end
    end
  end
end
