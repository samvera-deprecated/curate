require 'spec_helper'

describe Curate::OrganizationsController do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "#new" do
    it 'renders the form' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe "#create" do
    it "should be successful" do
      expect {
        post :create, organization:  { title: 'test title', description: 'test desc'}
      }.to change{Organization.count}.by(1)
      expect(response).to redirect_to organizations_path
      expect(flash[:notice]).to eq 'Organization created successfully.'
    end
  end

  describe "without access" do
    describe "#update" do
      let(:organization) { FactoryGirl.create(:organization) }
      it "should be able to update permissions" do
        patch :update, id: organization.id, visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'

        organization.reload.should_not be_open_access
      end
    end
  end

  describe "with access" do
    describe "#update" do
      let(:organization) { FactoryGirl.create(:organization, user: user) }
      it "should be able to update permissions" do
        patch :update, id: organization.id, organization: {visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC}
        expect(response).to redirect_to organization_path(organization)
        expect(flash[:notice]).to eq 'Ogranization updated successfully.'

        organization.reload.should be_open_access
      end
    end
  end

end
