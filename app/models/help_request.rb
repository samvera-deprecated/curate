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

  attr_reader :site_version

  belongs_to :user
  validates_presence_of :how_can_we_help_you,
    :message => "Please tell us about the problem or issue you are having with CurateND."

  after_initialize :set_release_version

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

  def set_release_version
    self.release_version ||= Rails.configuration.build_identifier
  end
end
