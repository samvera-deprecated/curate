class CurateContentDepositEventJob
  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include ActionView::Helpers::DateHelper
  include Hydra::AccessControlsEnforcement

  def queue_name
    :event
  end

  attr_accessor :generic_file_id, :depositor_id

  def initialize(generic_file_id, depositor_id)
    self.generic_file_id = generic_file_id
    self.depositor_id = depositor_id
  end

  def run
    gf = GenericFile.find(generic_file_id)
    action = "User #{depositor_id} has deposited #{gf.title} (#{gf.noid})"
    timestamp = Time.now.to_i
    depositor = User.find_by_user_key(depositor_id)

    event = depositor.create_event(action, timestamp)

    depositor.log_profile_event(event)

    gf.log_event(event)

    depositor.followers.select { |user| user.can? :read, gf }.each do |follower|
      follower.log_event(event)
    end
  end
end

Sufia.config do |c|
  c.temp_file_base = '/tmp'
  c.after_create_content = lambda {|generic_file, user|
    Sufia.queue.push(CurateContentDepositEventJob.new(generic_file.pid, user.user_key))
  }
end
