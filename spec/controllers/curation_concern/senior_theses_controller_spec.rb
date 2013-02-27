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
    subject {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    let(:pid) { CurationConcern.mint_a_pid }
    it 'should render' do
      sign_in user
      subject
      get :show, id: subject.pid
      response.should be_successful
      controller.curation_concern.should == subject
    end
  end
  describe '#edit' do
    subject {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    it 'should render' do
      sign_in user
      subject
      get :edit, id: subject.pid
      response.should be_successful
      controller.curation_concern.should == subject
      expect(response).to render_template('edit')
    end

    it 'should not be accessible by another user' do
      sign_in another_user
      get :edit, id: subject.pid
      response.status.should == 302
      expect(response).to redirect_to(root_url)
    end
  end
  describe '#update' do
    subject {
      FactoryGirl.create_curation_concern(:senior_thesis, user, valid_attributes)
    }
    it 'updates a Senior Thesis when valid' do
      sign_in user
      subject
      expect {
        put :update, id: subject.pid, senior_thesis: valid_attributes
      }.to_not change { SeniorThesis.count }.by(1)
      expected_path = controller.polymorphic_path([:curation_concern, subject])
      expect(response).to redirect_to(expected_path)
    end
    it 'does not create a Senior Thesis when invalid' do
      sign_in user
      subject
      put :update, id: subject.pid, senior_thesis: invalid_attributes
      expect(response).to render_template('edit')
      response.response_code.should == 422
    end
  end
  describe '#destroy' do
  end
end
