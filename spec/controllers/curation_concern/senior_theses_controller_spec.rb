require 'spec_helper'

describe CurationConcern::SeniorThesesController do
  render_views
  before(:each) do
    sign_in user
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:senior_thesis) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:senior_thesis_invalid) }
  let(:contributor_agreement) {
    # I need a contributor agreement object for param values
    ContributorAgreement.new(SeniorThesis.new, user, {})
  }

  describe '#new' do
    it 'should be successful' do
      get :new
      controller.curation_concern.should be_kind_of(SeniorThesis)
      response.should be_successful
    end
  end

  describe '#create' do
    it 'does not allow a thesis to be created when agreement is not set' do
      expect{
        post :create, senior_thesis: valid_attributes
      }.to_not change { SeniorThesis.count }
      expect(response).to render_template('new')
      response.response_code.should == 409
    end

    it 'creates a Senior Thesis when valid' do
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
    before(:all) do
      CurationConcern::Actions.create_metadata(subject, user, valid_attributes)
    end
    subject { SeniorThesis.new(pid: pid) }
    let(:pid) { CurationConcern.mint_a_pid }
    it 'should render' do
      get :show, id: subject.pid
      response.should be_successful
      controller.curation_concern.should == subject
    end
  end
  describe '#edit' do
    before(:all) do
      CurationConcern::Actions.create_metadata(subject, user, valid_attributes)
    end
    subject { SeniorThesis.new(pid: pid) }
    let(:pid) { CurationConcern.mint_a_pid }
    it 'should render' do
      get :edit, id: subject.pid
      response.should be_successful
      controller.curation_concern.should == subject
      expect(response).to render_template('edit')
    end
  end
  describe '#update' do
    before(:each) do
      sign_in user
      CurationConcern::Actions.create_metadata(subject, user, valid_attributes)
    end
    subject { SeniorThesis.new(pid: pid) }
    let(:pid) { CurationConcern.mint_a_pid }
    it 'updates a Senior Thesis when valid' do
      expect {
        put :update, id: pid, senior_thesis: valid_attributes
      }.to_not change { SeniorThesis.count }.by(1)
      expected_path = controller.polymorphic_path([:curation_concern, subject])
      expect(response).to redirect_to(expected_path)
    end
    it 'does not create a Senior Thesis when invalid' do
      put :update, id: pid, senior_thesis: invalid_attributes
      expect(response).to render_template('edit')
      response.response_code.should == 422
    end
  end
  describe '#destroy' do
  end
end
