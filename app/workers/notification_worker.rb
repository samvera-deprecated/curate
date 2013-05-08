class NotificationWorker
  def queue_name
    :help_request_notifications
  end

  attr_accessor :help_request_id

  def initialize(help_request_id)
    self.help_request_id = help_request_id
  end

  def run
    help_request = HelpRequest.find(help_request_id)
    NotificationMailer.notify(help_request).deliver
  end
end
