require "spec_helper"

describe NotificationMailer do

  def create_user
    @user = mock_model(User)
    @user.stub(:email).and_return("test@test.com")
    @user
  end

  def create_help_request
    @help_request = mock_model(HelpRequest)
    @help_request.stub(:sender_email).and_return(@user.email)
    @help_request.stub(:id).and_return(help_request_id)
    @help_request.stub(:current_url).and_return("http://localhost:3000/dashboard")
    @help_request.stub(:javascript_enabled).and_return("true")
    @help_request.stub(:user_agent).and_return("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0")
    @help_request.stub(:resolution).and_return("1680x1050")
    @help_request.stub(:how_can_we_help_you).and_return("This is a test message!")
    @help_request
  end

  let(:help_request_id) { 1 }

  let(:body) {
    "From: #{@help_request.sender_email}\n" +
    "URL: #{@help_request.current_url}\n" +
    "Javascript enabled: #{@help_request.javascript_enabled}\n" +
    "User Agent: #{@help_request.user_agent}\n" +
    "Resolution: #{@help_request.resolution}\n" +
    "Message: #{@help_request.how_can_we_help_you}"
  }

  let(:subject){
    "#{I18n.t('sufia.product_name')}: Help Request - #{help_request_id} [#{Rails.env}]"
  }

  let(:sender_email_id){
    "test@test.com"
  }

  before(:each) {
    create_user
    create_help_request
  }

  it 'should notify to the recipient' do
    email = NotificationMailer.notify(@help_request).deliver

    email.from.first.should == sender_email_id

    email.subject.should == subject

    email.body.to_s.should == body
  end

end
