require 'curate/jobs/content_deposit_event_job'

Sufia.config do |c|
  c.temp_file_base = '/tmp'
  c.after_create_content = lambda {|generic_file, user|
    Sufia.queue.push(Curate::ContentDepositEventJob.new(generic_file.pid, user.user_key))
  }
end
