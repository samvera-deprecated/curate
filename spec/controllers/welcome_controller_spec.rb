require 'spec_helper'

describe WelcomeController do
  describe '#index' do
    it 'should get a page' do
      get :index
      response.status.should == 200
    end
  end
end
