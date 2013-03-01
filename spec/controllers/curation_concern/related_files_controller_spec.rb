require 'spec_helper'

describe CurationConcern::RelatedFilesController do
  render_views
  let(:parent_curation_concern) {
    FactoryGirl.create_curation_concern(:senior_thesis, user)
  }
  subject { FactoryGirl.create_generic_file(parent_curation_concern, user)}
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user)  { FactoryGirl.create(:user) }
  let(:file) {Rack::Test::UploadedFile.new(__FILE__, 'text/plain', false)}
  it 'has a #parent_curation_concern' do
    controller.params[:parent_curation_concern_id] = parent_curation_concern.noid
    controller.parent_curation_concern.should == parent_curation_concern
  end

  describe '#new' do
    it 'renders a form if you can edit the parent' do
      sign_in(user)
      parent_curation_concern
      get :new, parent_curation_concern_id: parent_curation_concern.to_param
      expect(response).to render_template('new')
    end

    it 'renders a form if you can edit the parent' do
      sign_in(another_user)
      parent_curation_concern
      get :new, parent_curation_concern_id: parent_curation_concern.to_param
      response.status.should == 302
      expect(response).to redirect_to(root_url)
    end
  end

  let(:actor) { double('actor') }
  let(:actors_action) { nil }
  let(:failing_actor) {
    actor.
    should_receive(actors_action).
    and_raise(ActiveFedora::RecordInvalid.new(ActiveFedora::Base.new))
    actor
  }
  let(:successful_actor) {
    actor.should_receive(actors_action).and_return(true)
    actor
  }
  describe '#create' do
    let(:actors_action) { :create! }

    it 'redirects to parent when successful' do
      sign_in(user)
      parent_curation_concern
      controller.actor = successful_actor

      post(
        :create,
        parent_curation_concern_id: parent_curation_concern.to_param,
        generic_file: { title: "Title", file: file }
      )

      expect(response).to(
        redirect_to(
          controller.polymorphic_path(
            [:curation_concern, parent_curation_concern]
          )
        )
      )
    end

    it 'renders form when unsuccessful' do
      sign_in(user)
      parent_curation_concern
      controller.actor = failing_actor

      post(
        :create,
        parent_curation_concern_id: parent_curation_concern.to_param,
        generic_file: { title: "Title", file: file }
      )

      expect(response).to render_template('new')
      response.status.should == 422
    end
  end

end
