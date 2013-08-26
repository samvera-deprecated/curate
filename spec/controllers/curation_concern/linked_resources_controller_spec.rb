require 'spec_helper'

describe CurationConcern::LinkedResourcesController do
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:visibility) { AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
  let(:parent) {
    FactoryGirl.create_curation_concern(:generic_work, user, {visibility: visibility})
  }
  let(:you_tube_link) { 'http://www.youtube.com/watch?v=oHg5SJYRHA0' }

  describe '#new' do
    it 'renders a form if you can edit the parent' do
      sign_in(user)
      parent
      get :new, parent_id: parent.to_param
      expect(response).to render_template(:new)
      response.should be_successful
    end

    it 'redirects if you cannot edit the parent' do
      sign_in(another_user)
      parent
      expect {
        get :new, parent_id: parent.to_param
      }.to raise_rescue_response_type(:unauthorized)
    end
  end

  describe '#create' do
    let(:actor) { double('actor') }
    let(:actors_action) { :create! }
    let(:invalid_exception) {
      ActiveFedora::RecordInvalid.new(ActiveFedora::Base.new)
    }
    let(:failing_actor) {
      actor.should_receive(actors_action).and_raise(invalid_exception)
      actor
    }
    let(:successful_actor) {
      actor.should_receive(actors_action).and_return(true)
      actor
    }

    it 'redirects to the parent work' do
      sign_in(user)
      parent
      controller.actor = successful_actor

      post(:create, parent_id: parent.to_param,
           linked_resource: { url: you_tube_link }
      )

      expect(response).to(
        redirect_to(controller.polymorphic_path([:curation_concern, parent]))
      )
    end

    describe 'failure' do
      it 'renders the form' do
        sign_in(user)
        parent
        controller.actor = failing_actor

        post(:create, parent_id: parent.to_param,
             linked_resource: { url: you_tube_link }
        )
        expect(response).to render_template('new')
        response.status.should == 422
      end
    end
  end

end
