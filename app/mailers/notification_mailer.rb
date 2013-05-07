class NotificationMailer < ActionMailer::Base

  def notify(help_request)
    mail(to: recipients_list,
        subject: "CurateND: Help Request - #{help_request.id}",
        body: prepare_body(help_request))
  end

  private

  def prepare_body(help_request)
    body  = "From: #{help_request.user.email}\n"
    body += "URL: #{help_request.current_url}\n"
    body += "Javascript enabled: #{help_request.javascript_enabled}\n"
    body += "User Agent: #{help_request.user_agent}\n"
    body += "Resolution: #{help_request.resolution}\n"
    body += "Message: #{help_request.how_can_we_help_you}"
    body
  end

  def recipients_list
    return @list if !@list.nil?
    @list = YAML.load(File.open(File.join(Rails.root, "config/recipients_list.yml"))).split(" ")
    return @list
  end
end

