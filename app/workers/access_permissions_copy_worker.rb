class AccessPermissionsCopyWorker
  class PidError < RuntimeError
    def initialize(url_string)
      super(url_string)
    end
  end
  def queue_name
    :permissions
  end

  attr_accessor :pid

  def initialize(pid)
    if pid.blank?
      raise PidError.new("PID required.")
    end
    self.pid = pid
  end

  def run
    work = ActiveFedora::Base.find(pid, cast: true)
    if work.respond_to?(:generic_files)
      work.generic_files.each do |file|
        file.edit_users = work.edit_users
        file.edit_groups = work.edit_groups
        file.save!
      end    
    end
  end
end
