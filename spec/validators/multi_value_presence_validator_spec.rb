require 'spec_helper'

describe MultiValuePresenceValidator do
  let(:validatable) do
    Class.new do
      def self.name
        'Validatable'
      end
      include ActiveModel::Validations
      attr_accessor :contributors
      validates :contributors, multi_value_presence: true
    end
  end
  subject { validatable.new }

  before do
    subject.contributors = contributors
    subject.valid?
  end

  context 'an empty array' do
    let(:contributors) { [] }
    it { expect(subject.errors.messages).to eq contributors: ['can\'t be blank'] }
  end

  context 'an array with one empty item' do
    let(:contributors) { ['']  }
    it { expect(subject.errors.messages).to eq contributors: ['can\'t be blank'] }
  end

  context 'an array with one empty item and one non-empty' do
    let(:contributors) { ['', 'Hello']  }
    it { expect(subject.errors.messages).to eq({}) }
  end

  context 'an array with first and last elements that are empty' do
    let(:contributors) { ['', 'Hello', '']  }
    it { expect(subject.errors.messages).to eq({}) }
  end

end
