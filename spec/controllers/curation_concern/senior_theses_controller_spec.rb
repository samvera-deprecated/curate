require 'spec_helper'

describe CurationConcern::SeniorThesesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:senior_thesis) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:senior_thesis_invalid) }
  let(:contributor_agreement) {
    # I need a contributor agreement object for param values
    ContributorAgreement.new(SeniorThesis.new, user, {})
  }

  describe '#new' do
    it 'should be successful' do
      sign_in user
      get :new
      controller.curation_concern.should be_kind_of(SeniorThesis)
      response.should be_successful
    end
  end

  describe '#create' do
    it 'does not allow a thesis to be created when agreement is not set' do
      sign_in user
      expect{
        post :create, senior_thesis: valid_attributes
      }.to_not change { SeniorThesis.count }
      expect(response).to render_template('new')
      response.response_code.should == 409
    end

    it 'creates a Senior Thesis when valid' do
      sign_in user
      expect {
        post(
          :create,
          :senior_thesis => valid_attributes,
          contributor_agreement.param_key => contributor_agreement.acceptance_value
        )
      }.to change { SeniorThesis.count }.by(1)
      expected_path = controller.polymorphic_path([:curation_concern, controller.curation_concern])
      expect(response).to redirect_to(expected_path)
    end

    it 'creates senior thesis, then prompt for related files' do
      sign_in user
      post(
        :create,
        :senior_thesis => valid_attributes,
        :commit => controller.save_and_add_related_files_submit_value('create'),
        contributor_agreement.param_key => contributor_agreement.acceptance_value
      )

      expected_path = controller.new_curation_concern_generic_file_path(controller.curation_concern)
      expect(response).to redirect_to(expected_path)
    end

    it 'does not create a Senior Thesis when invalid' do
      sign_in user
      post(
        :create,
        senior_thesis: invalid_attributes,
        contributor_agreement.param_key => contributor_agreement.acceptance_value
      )
      expect(response).to render_template('new')
      response.response_code.should == 422
    end
  end

  describe '#show' do
    let(:senior_thesis) {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    let(:pid) { CurationConcern.mint_a_pid }
    it 'should render' do
      sign_in user

      get :show, id: senior_thesis.to_param
      response.should be_successful
      controller.curation_concern.should == senior_thesis
    end
  end
  describe '#edit' do
    let(:senior_thesis) {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    it 'should render' do
      sign_in user

      get :edit, id: senior_thesis.to_param
      response.should be_successful
      controller.curation_concern.should == senior_thesis
      expect(response).to render_template('edit')
    end

    it 'should not be accessible by another user' do
      sign_in another_user
      expect {
        get :edit, id: senior_thesis.to_param
      }.to raise_rescue_response_type(:unauthorized)
    end
  end
  describe '#update' do
    let(:senior_thesis) {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    it 'updates a Senior Thesis when valid' do
      sign_in user
      senior_thesis
      expect {
        put :update, id: senior_thesis.to_param, senior_thesis: valid_attributes
      }.to_not change { SeniorThesis.count }.by(1)
      expected_path = controller.polymorphic_path([:curation_concern, senior_thesis])
      expect(response).to redirect_to(expected_path)
    end
    it 'does not create a Senior Thesis when invalid' do
      sign_in user

      put :update, id: senior_thesis.to_param, senior_thesis: invalid_attributes
      expect(response).to render_template('edit')
      response.response_code.should == 422
    end
  end
  describe '#destroy' do
    let(:senior_thesis) {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }

    it 'deletes an object' do
      sign_in user
      delete :destroy, id: senior_thesis.to_param
      expect(response.status).to eq(302)
      expect(response).to redirect_to(dashboard_index_path)
    end
  end
end
