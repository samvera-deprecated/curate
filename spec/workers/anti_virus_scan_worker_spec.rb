require 'spec_helper'

describe AntiVirusScanWorker do
  subject { AntiVirusScanWorker.new(pid) }
  let(:pid) { 'a1b2c3' }
  it { subject.queue_name.should == :anti_virus }
end