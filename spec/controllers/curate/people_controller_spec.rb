require 'spec_helper'

describe Curate::PeopleController do
  describe "#show" do
    let(:person) { FactoryGirl.create(:person_with_user) }
    let(:user) { person.user }
    let(:a_different_user) { FactoryGirl.create(:user) }

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

  describe "searching via json" do
    let!(:katie) { FactoryGirl.create(:person, name: 'Katie F. White-Kopp') }
    let!(:alvin) { FactoryGirl.create(:person, name: 'A. S. Mitchell') }
    let!(:john)  { FactoryGirl.create(:person, name: 'John Corcoran III') }

    after do
      katie.destroy
      alvin.destroy
      john.destroy
    end

    it "should return results on full first name match" do
      get :index, q: 'Katie', format: :json
      json = JSON.parse(response.body)
      json['response']['docs'].should == [{"id"=>katie.pid, "desc_metadata__name_tesim"=>["Katie F. White-Kopp"]}]
    end

    it "should return results on full last name match" do
      get :index, q: 'Mitchell', format: :json
      json = JSON.parse(response.body)
      json['response']['docs'].should == [{"id"=>alvin.pid, "desc_metadata__name_tesim"=>["A. S. Mitchell"]}]
    end


  end
end
