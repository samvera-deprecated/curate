class VisibilityCopyWorker
  def queue_name
    :permissions
  end

  attr_accessor :pid

  def initialize(pid)
    self.pid = pid
  end

  def run
    work = ActiveFedora::Base.load_instance_from_solr(pid)
    work.generic_files.each do |file|
      file.visibility = work.visibility
      file.save!
    end    
  end
end

