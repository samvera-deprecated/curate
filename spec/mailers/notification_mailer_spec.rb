require "spec_helper"

describe NotificationMailer do

  def create_user
    @user = User.new
    @user.email = "test@test.com"
  end

  def create_help_request
    @help_request = HelpRequest.new
    @help_request.user = @user
    @help_request.id = help_request_id
    @help_request.current_url = "http://localhost:3000/dashboard"
    @help_request.javascript_enabled = "true"
    @help_request.user_agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0"
    @help_request.resolution = "1680x1050"
    @help_request.how_can_we_help_you = "This is a test message!"
  end

  let(:help_request_id) { 1 }

  let(:body) { 
    "From: #{@help_request.user.email}\n" + 
    "URL: #{@help_request.current_url}\n" +
    "Javascript enabled: #{@help_request.javascript_enabled}\n" +
    "User Agent: #{@help_request.user_agent}\n" +
    "Resolution: #{@help_request.resolution}\n" +
    "Message: #{@help_request.how_can_we_help_you}"
  }

  let(:subject){
    "CurateND: Help Request - #{help_request_id}"
  }

  before(:each) { 
    create_user
    create_help_request
  }

  it 'should notify to the recipient' do
    email = NotificationMailer.notify(@help_request).deliver
    email.subject.should == subject
    email.body.to_s.should == body
  end
end
