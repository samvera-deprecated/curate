class NotificationMailer < ActionMailer::Base

  def notify(help_request)
    mail(from: sender_email(help_request),
        to: recipients_list,
        subject: "#{t('sufia.product_name')}: Help Request - #{help_request.id} [#{Rails.env}]",
        body: prepare_body(help_request))
  end

  private

  def prepare_body(help_request)
    body  = "From: #{sender_email(help_request)}\n"
    body += "URL: #{help_request.current_url}\n"
    body += "Javascript enabled: #{help_request.javascript_enabled}\n"
    body += "User Agent: #{help_request.user_agent}\n"
    body += "Resolution: #{help_request.resolution}\n"
    body += "Message: #{help_request.how_can_we_help_you}"
    body
  end

  def recipients_list
    return @list if !@list.blank?
    @list = YAML.load(File.open(File.join(Rails.root, "config/recipients_list.yml"))).split(" ")
    return @list
  end

  def sender_email(help_request)
    help_request.sender_email.blank? ? default_sender : help_request.sender_email
  end

  def default_sender
    @sender ||= YAML.load(File.open(File.join(Rails.root, "config/smtp_config.yml")))
    return @sender[Rails.env]["smtp_user_name"]
  end
end

