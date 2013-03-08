require 'spec_helper'

describe CommonObjectsController do
  render_views

  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:template_for_success) { 'show' }
    let(:template_for_unauthorized ) { '/errors/unauthorized' }
    let(:another_user) { FactoryGirl.create(:user) }
    let(:visibility) { nil }
    let(:curation_concern) {
      FactoryGirl.create_curation_concern(:senior_thesis, user, visibility: visibility)
    }
    describe '"Open Access" object' do
      let(:visibility) { 'open' }
      it 'renders for unauthenticated person' do
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end

      it 'renders for the creator' do
        sign_in(user)
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end

      it 'renders for the another user' do
        sign_in(another_user)
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end
    end

    describe '"Restricted" object' do
      let(:visibility) { 'restricted' }
      it 'does not display for unauthenticated person' do
        get :show, id: curation_concern.to_param
        response.status.should == 401
        expect(response).to render_template(template_for_unauthorized)
      end

      it 'renders for the creator' do
        sign_in(user)
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end

      it 'renders for the creator' do
        sign_in(another_user)
        get :show, id: curation_concern.to_param
        response.status.should == 401
        expect(response).to render_template(template_for_unauthorized)
      end
    end
    describe '"Institution Only" object' do
      let(:visibility) { 'psu' }
      it 'does not display for unauthenticated person' do
        get :show, id: curation_concern.to_param
        response.status.should == 401
        expect(response).to render_template(template_for_unauthorized)
      end

      it 'renders for the creator' do
        sign_in(user)
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end

      it 'renders for the creator' do
        sign_in(another_user)
        get :show, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end
    end
  end

end
