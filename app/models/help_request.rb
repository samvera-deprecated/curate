require 'browser'
class HelpRequest < ActiveRecord::Base

  attr_accessible(
    :current_url,
    :flash_version,
    :how_can_we_help_you,
    :javascript_enabled,
    :resolution,
    :user_agent,
    :view_port
  )

  belongs_to :user
  validates_presence_of :how_can_we_help_you,
    :message => "Please tell us about the problem or issue you are having with CurateND."

  after_save :send_notification

  def browser_name
    parse_user_agent
    @browser.name
  end

  def platform
    parse_user_agent
    @browser.platform
  end

  private

  def parse_user_agent
    @browser ||= Browser.new(:ua => user_agent)
  end

  def send_notification
    NotificationMailer.notify(self).deliver
  end
end
