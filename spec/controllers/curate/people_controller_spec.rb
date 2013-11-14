require 'spec_helper'

describe Curate::PeopleController do
  describe "#show" do
    let(:person) { FactoryGirl.create(:person_with_user) }
    context 'my own person page' do
      before { sign_in person.user }

      it "should show me the page" do
        get :show, id: person.pid
        expect(response).to be_success
        assigns(:person).should == person
      end
    end

    context 'someone elses person page' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it "should show me the page" do
        get :show, id: person.pid
        expect(response).to be_success
      end
    end
  end

  describe "searching via json" do
    before(:each) do
      @katie = FactoryGirl.create(:person, name: 'Katie F. White-Kopp')
      @alvin = FactoryGirl.create(:person, name: 'A. S. Mitchell')
      @john = FactoryGirl.create(:person_with_user, name: 'John Corcoran III')
    end

    it "should return results on full first name match" do
      get :index, q: 'Katie', format: :json
      json = JSON.parse(response.body)
      json['response']['docs'].should == [{"id"=>@katie.pid, "desc_metadata__name_tesim"=>["Katie F. White-Kopp"]}]
    end

    it "should return results on full last name match" do
      get :index, q: 'Mitchell', format: :json
      json = JSON.parse(response.body)
      json['response']['docs'].should == [{"id"=>@alvin.pid, "desc_metadata__name_tesim"=>["A. S. Mitchell"]}]
    end

    describe "when constrained to users" do
      it "should return users" do
        get :index, q: '', user: true, format: :json
        json = JSON.parse(response.body)
        json['response']['docs'].should == [{"id"=>@john.pid, "desc_metadata__name_tesim"=>["John Corcoran III"]}]
      end
    end


  end
end
