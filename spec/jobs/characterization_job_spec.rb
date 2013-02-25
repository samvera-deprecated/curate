require 'spec_helper'

describe 'CharacterizationJob' do
  let(:curation_concern) {
    double('generic_file').tap {|obj|
      obj.stub(:pid).and_return('12')
      obj.should_receive(:characterize)
      obj.should_receive(:create_thumbnail)
      obj.should_receive(:video?).and_return(false)
    }
  }
  subject { CharacterizationJob.new(curation_concern.pid) }

  it 'characterizes and builds a thumbnail' do
    ActiveFedora::Base.should_receive(:find).with(curation_concern.pid, cast:true).and_return(curation_concern)
    subject.run
  end
end
