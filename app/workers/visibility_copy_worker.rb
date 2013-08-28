class VisibilityCopyWorker
  def queue_name
    :permissions
  end

  attr_accessor :pid

  def initialize(pid)
    self.pid = pid
  end

  def run
    # TODO fill in to satisfy https://github.com/ndlib/planning/issues/104
  end
end

