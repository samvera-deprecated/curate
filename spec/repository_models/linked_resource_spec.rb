require 'spec_helper'

describe LinkedResource do
  subject { LinkedResource.new }

  it { should respond_to(:human_readable_type) }

  it 'has a #human_readable_short_description' do
    subject.human_readable_short_description.length.should_not == 0
  end

  it 'has a .human_readable_short_description' do
    subject.class.human_readable_short_description.length.should_not == 0
  end

  it 'uses #noid for #to_param' do
    subject.stub(:persisted?).and_return(true)
    subject.to_param.should == subject.noid
  end

  it 'has no url to display' do
    subject.to_s.should == nil
  end

  describe "with a persisted resource" do
    let!(:resource) { FactoryGirl.create(:linked_resource, url: 'http://www.youtube.com/watch?v=oHg5SJYRHA0') }
    after do
      resource.batch.destroy
    end

    it 'has url as its title to display' do
      expect(resource.to_s).to eq 'http://www.youtube.com/watch?v=oHg5SJYRHA0'
    end
  end

end
