require 'spec_helper'

describe Curate::PeopleController, with_callbacks: true do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:person) { user.person }
  let(:a_different_user) { FactoryGirl.create(:user) }

  describe "#show" do
    context 'my own person page' do
      before do
        sign_in user
        get :show, id: person.pid
      end

      it "should show me the page" do
        expect(response).to be_success
      end

      it "assigns person" do
        assigns(:person).should == person
      end
    end

    context 'someone elses person page' do
      before { sign_in a_different_user }

      it "should show me the page" do
        get :show, id: person.pid
        expect(response).to be_success
      end
    end
  end

end
