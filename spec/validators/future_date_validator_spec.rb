require 'spec_helper'

describe FutureDateValidator do

  let(:validatable) do
    Class.new do
      def self.name
        'Validatable'
      end
      include ActiveModel::Validations
      attr_accessor :a_date
      validates :a_date, future_date: true
    end
  end
  subject { validatable.new }

  before do
    subject.a_date = a_date
    subject.valid?
  end

  context 'with today as embargo release date' do
    let(:a_date) { Date.today.to_s }
    it { expect(subject.errors.messages).to eq :a_date => ["Must be a future date"] }
  end

  context 'with past date as embargo release date' do
    let(:a_date) { (Date.today - 2).to_s  }
    it { expect(subject.errors.messages).to eq :a_date => ["Must be a future date"] }
  end

  context 'invalid date as embargo release date' do
    let(:a_date) { "invalid_ date" }
    it { expect(subject.errors.messages).to eq :a_date => ["Invalid Date Format"] }
  end

  context 'future date as embargo release date' do
    let(:a_date) { (Date.today + 2).to_s    }
    it { expect(subject.errors.messages).to eq({}) }
  end

end