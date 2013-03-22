require 'spec_helper'

class Validatable
  include ActiveModel::Validations
  attr_accessor :embargo_release_date
  validates :embargo_release_date, future_date: true
end

describe FutureDateValidator do

  subject { Validatable.new }

  before { subject.embargo_release_date = embargo_release_date }

  context 'with today as embargo release date' do
    let(:embargo_release_date) { Date.today.to_s    }
    it { should have(1).error_on(:embargo_release_date) }
  end

  context 'with past date as embargo release date' do
    let(:embargo_release_date) { (Date.today - 2).to_s  }
    it { should have(1).error_on(:embargo_release_date) }
  end

  context 'invalid date as embargo release date' do
    let(:embargo_release_date) { "invalid_ date" }
    it { should have(1).error_on(:embargo_release_date) }
  end

  context 'future date as embargo release date' do
    let(:embargo_release_date) { (Date.today + 2).to_s    }
    it { should have(:no).error_on(:embargo_release_date) }
  end

end