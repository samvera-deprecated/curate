require 'spec_helper'

describe CurationConcern::SeniorThesesController do
  render_views
  before(:each) do
    sign_in user
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:senior_thesis) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:senior_thesis_invalid) }

  describe '#new' do
    it 'should be successful' do
      get :new
      controller.senior_thesis.should be_kind_of(SeniorThesis)
      response.should be_successful
    end
  end

  describe '#create' do
    it 'creates a Senior Thesis when valid' do
      expect {
        post :create, senior_thesis: valid_attributes
      }.to change { SeniorThesis.count }.by(1)
      expected_path = controller.polymorphic_path([:curation_concern, controller.senior_thesis])
      expect(response).to redirect_to(expected_path)
    end
    it 'does not create a Senior Thesis when invalid' do
      post :create, senior_thesis: invalid_attributes
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
      controller.senior_thesis.should == subject
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
      controller.senior_thesis.should == subject
      expect(response).to render_template('edit')
    end
  end
  describe '#update' do
    before(:all) do
      CurationConcern::Actions.create_metadata(subject, user, valid_attributes)
    end
    subject { SeniorThesis.new(pid: pid) }
    let(:pid) { CurationConcern.mint_a_pid }
  end
  describe '#destroy' do
  end
end
