require 'spec_helper'

describe AntiVirusScanner do
  let(:object) { GenericFile.new }
  let(:file_path) { __FILE__ }
  subject { AntiVirusScanner.new(object) }
  let(:always_clean_scanner) { lambda {|o| 0 } }
  let(:always_has_virus_scanner) { lambda {|o| 1 } }
  describe '#call' do
    it 'returns true if anti-virus is successful' do
      subject.scanner_instance = always_clean_scanner
      expect(subject.call(file_path)).to eq(true)
    end

    it 'raise an exception if anti-virus failed' do
      subject.scanner_instance = always_has_virus_scanner
      expect {
        subject.call(file_path)
      }.to raise_error(AntiVirusScanner::VirusDetected)
    end
  end
end