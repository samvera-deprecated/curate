require 'spec_helper'

describe CommonObjectsController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:visibility) { nil }
  let(:curation_concern) {
    FactoryGirl.create_curation_concern(:senior_thesis, user, visibility: visibility)
  }
  describe '#show' do
    let(:template_for_success) { 'show' }
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
      it 'redirect to DOI information for unauthenticated person' do
        get :show, id: curation_concern.to_param
        response.status.should == 302
        expect(response).to redirect_to(common_object_stub_information_path(curation_concern))
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
        response.status.should == 302
        expect(response).to redirect_to(common_object_stub_information_path(curation_concern))
      end
    end
    describe '"Institution Only" object' do
      let(:visibility) { 'psu' }
      it 'does not display for unauthenticated person' do
        get :show, id: curation_concern.to_param
        response.status.should == 302
        expect(response).to redirect_to(common_object_stub_information_path(curation_concern))
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

  describe '#show_stub_information' do
    let(:template_for_success) { 'show_stub_information' }
    describe '"Open Access" object' do
      let(:visibility) { 'open' }
      it 'renders rudimentary DOI information' do
        get :show_stub_information, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end
    end
    describe '"Restricted" object' do
      let(:visibility) { 'restricted' }
      it 'renders rudimentary DOI information' do
        get :show_stub_information, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end
    end
    describe '"Institution Only" object' do
      let(:visibility) { 'psu' }
      it 'renders rudimentary DOI information' do
        get :show_stub_information, id: curation_concern.to_param
        response.status.should == 200
        expect(response).to render_template(template_for_success)
      end
    end
  end
end
