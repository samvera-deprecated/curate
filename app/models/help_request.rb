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

  attr_reader :application_version
  attr_reader :release_version

  belongs_to :user
  validates_presence_of :how_can_we_help_you,
    :message => "Please tell us about the problem or issue you are having with CurateND."

  after_initialize :set_application_version
  before_create :set_release_version

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

  # We don't want the release version to be set directly by the user.
  # However, we need to display the application verson _before_ the record is saved.
  def set_application_version
    if self.release_version
      @application_version = self.release_version
    else
      @application_version = Rails.configuration.build_identifier
    end
  end

  def set_release_version
    self.release_version = self.application_version
  end
end
