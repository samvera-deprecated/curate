require 'spec_helper'

describe CurationConcern::GenericFilesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  let(:generic_file) { FactoryGirl.create_generic_file(:senior_thesis, user) }
  let(:another_user) { FactoryGirl.create(:user) }
  describe '#edit' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :edit, id: generic_file.to_param
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end
  end

  describe '#update' do
    let(:updated_title) { Time.now.to_s }
    let(:failing_actor) {
      actor.
        should_receive(:update!).
        and_raise(ActiveFedora::RecordInvalid.new(ActiveFedora::Base.new))
      actor
    }
    let(:successful_actor) {
      actor.should_receive(:update!).and_return(true)
      actor
    }
    let(:actor) { double('actor') }
    it 're-renders when update fails' do
      generic_file
      controller.actor = failing_actor
      sign_in(user)
      put :update, id: generic_file.to_param, generic_file: {title: updated_title}
      expect(response).to render_template('edit')
      response.status.should == 422
    end

    it 'updates' do
      generic_file
      sign_in(user)
      put :update, id: generic_file.to_param, generic_file: {title: updated_title}
      response.status.should == 302
      expect(response).to(
        redirect_to(
          controller.polymorphic_path([:curation_concern, generic_file])
        )
      )
    end
  end

  describe '#show' do
    it 'should be successful' do
      generic_file
      sign_in user
      get :show, id: generic_file.to_param
      controller.curation_concern.should be_kind_of(GenericFile)
      response.should be_successful
    end

    it 'does not allow another user to view it' do
      generic_file
      sign_in another_user
      get :show, id: generic_file.to_param
      response.status.should == 302
      expect(response).to redirect_to(root_url)
    end
  end

end
