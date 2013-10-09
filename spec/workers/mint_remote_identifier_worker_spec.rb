require 'spec_helper'

describe MintRemoteIdentifierWorker do
  let(:pid) { 'abc' }
  let(:target) { double }
  let(:remote_service_name) { :doi }
  let(:minter) {
    lambda { |name, target|
      target.remote_service_name = name
    }
  }
  before(:each) do
    ActiveFedora::Base.should_receive(:find).with(pid).and_return(target)
    Hydra::RemoteIdentifier.should_receive(:mint).with(remote_service_name, target)
  end

  subject { MintRemoteIdentifierWorker.new(pid, remote_service_name) }

  specify {
    subject.run
  }
end
