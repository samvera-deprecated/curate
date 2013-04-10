require 'spec_helper'

describe TermsOfServiceAgreementsController do
  before(:each) do
    sign_in(user)
  end
  describe 'without already agreeing' do
    let(:user) { FactoryGirl.create(:user, agreed_to_terms_of_service: false) }

    describe '#new' do
      it 'renders a form for agreement if not already agreed' do
        get :new
        response.status.should == 200
        expect(response).to render_template('new')
      end
    end
    describe '#create' do
      it 'redirects to remember location if agreed' do
        post :create, commit: controller.i_agree_text
        response.status.should == 302
        expect(response).to redirect_to(new_classify_concern_path)
      end
      it 'flashes a notice if you disagree and renders new' do
        post :create, commit: controller.i_do_not_agree_text
        expect(response).to render_template('new')
        response.response_code.should == 200
      end
    end
  end
end
