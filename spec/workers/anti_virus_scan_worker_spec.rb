require 'spec_helper'

describe AntiVirusScanWorker do
  subject { AntiVirusScanWorker.new(pid, file.path) }
  let(:file) { File.new(__FILE__) }
  let(:pid) { 'a1b2c3' }
  let(:mock_anti_virus_instance) { lambda {|path| anti_virus_scan_status } }
  let(:anti_virus_scan_status) { nil }

  it { subject.queue_name.should == :anti_virus }
  before(:each) do
    subject.anti_virus_instance = mock_anti_virus_instance
  end
  describe 'successful anti virus scan' do
    let(:anti_virus_scan_status) { 0 }
    it 'runs the file upload'
  end
  describe 'failed anti virus scan' do
    let(:anti_virus_scan_status) { 1 }
    it 'raises an exception' do
      expect {
        subject.run
      }.to raise_error(AntiVirusScanWorker::AntiVirusScanFailure)
    end
  end
end