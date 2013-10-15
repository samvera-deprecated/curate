require 'spec_helper'

describe Curate::DepositorsController do
  let (:person) { FactoryGirl.create(:person_with_user) }
  let (:grantee) { FactoryGirl.create(:person_with_user) }

  describe "as a logged in user" do
    before do
      sign_in person.user
    end

    describe "create" do
      it "should be successful" do
        expect { post :create, person_id: person.id, grantee_id: grantee.id, format: 'json' }.to change{ Curate::ProxyDepositRights.count }.by(1)
        response.should be_success
      end

      it "should not add current user" do
        expect { post :create, person_id: person.id, grantee_id: person.id, format: 'json' }.to change{ Curate::ProxyDepositRights.count }.by(0)
        response.should be_success
        response.body.should == "{}"
      end

    end
    describe "destroy" do
      before do
        person.user.can_receive_deposits_from << grantee.user
      end
      it "should be successful" do
        expect { delete :destroy, person_id: person.id, id: grantee.id, format: 'json' }.to change{ Curate::ProxyDepositRights.count }.by(-1)
      end
    end
  end

  describe "as a user without access" do
    before do
      sign_in FactoryGirl.create(:user)
    end
    describe "create" do
      it "should be successful" do
        post :create, person_id: person, grantee_id: grantee, format: 'json'
        expect(response.body).to eq "{\"status\":\"ERROR\",\"code\":401}"
      end
    end
    describe "destroy" do
      it "should be successful" do
        delete :destroy, person_id: person, id: grantee, format: 'json'
        expect(response.body).to eq "{\"status\":\"ERROR\",\"code\":401}"
      end
    end
  end
end
