class BaseJob
  def self.enqueue(*args)
    Sufia.queue.push(new(*args))
  end
end