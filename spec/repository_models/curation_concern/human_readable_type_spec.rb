require 'spec_helper'

describe CurationConcern::HumanReadableType do
  let(:klass) {
    Class.new {
      def self.name; 'HelloWorld';end
      include CurationConcern::HumanReadableType
    }
  }

  it 'should have .human_readable_type' do
    expect(klass.human_readable_type).to eq('Hello World')
  end
  it 'should have #human_readable_type' do
     expect(klass.new.human_readable_type).to eq('Hello World')
  end
end
