shared_examples 'is_a_curation_concern_controller' do |collection_class, actions = :all|
  def self.optionally_include_specs(actions, action_name)
    normalized_actions = Array(actions).flatten.compact
    return true if normalized_actions.include?(:all)
    return true if normalized_actions.include?(action_name.to_sym)
    return true if normalized_actions.include?(action_name.to_s)
  end
  its(:curation_concern_type) { should eq collection_class }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  let(:curation_concern_type_underscore) { collection_class.name.underscore }
  let(:default_work_factory_name) { curation_concern_type_underscore }
  let(:private_work_factory_name) { "private_#{curation_concern_type_underscore}".to_sym }
  let(:public_work_factory_name) { "public_#{curation_concern_type_underscore}".to_sym }

  def path_to_curation_concern
    public_send("curation_concern_#{curation_concern_type_underscore}_path", controller.curation_concern)
  end

  if optionally_include_specs(actions, :show)
    describe "#show" do
      context "my own private work" do
        let(:a_work) { FactoryGirl.create(private_work_factory_name, user: user) }
        it "should show me the page" do
          get :show, id: a_work
          expect(response).to be_success
        end
      end
      context "someone elses private work" do
        let(:a_work) { FactoryGirl.create(private_work_factory_name) }
        it "should show 401 Unauthorized" do
          get :show, id: a_work
          expect(response.status).to eq 401
        end
      end
      context "someone elses public work" do
        let(:a_work) { FactoryGirl.create(public_work_factory_name) }
        it "should show me the page" do
          get :show, id: a_work
          expect(response).to be_success
        end
      end
    end

    if optionally_include_specs(actions, :create)
      describe "#create" do
        it "should create a work" do
          controller.curation_concern.stub(:persisted?).and_return(true)
          controller.actor = double(:create! => true)
          post :create, accept_contributor_agreement: "accept"
          response.should redirect_to path_to_curation_concern
        end
      end
    end

    if optionally_include_specs(actions, :update)
      describe "#update" do
        let(:a_work) { FactoryGirl.create(default_work_factory_name, user: user) }
        it "should update the work " do
          controller.actor = double(:update! => true, :visibility_changed? => false)
          patch :update, id: a_work
          response.should redirect_to path_to_curation_concern
        end
        describe "changing rights" do
          it "should prompt to change the files access" do
            controller.actor = double(:update! => true, :visibility_changed? => true)
            patch :update, id: a_work
            response.should redirect_to confirm_curation_concern_permission_path(controller.curation_concern)
          end
        end
      end
    end

  end
end
