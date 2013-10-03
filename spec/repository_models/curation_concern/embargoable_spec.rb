require 'spec_helper'
require 'ostruct'

describe CurationConcern::Embargoable do 

  before do
    module MockVisibility
      def visibility
        'open'
      end
    end
  end

  let(:model) {
    Class.new(ActiveFedora::Base) {
      def save(returning_value = true)
        valid? && run_callbacks(:save) && !!returning_value
      end
      def read_groups
        ['public']
      end

      include MockVisibility
      include CurationConcern::Embargoable
    }
  }


  let(:persistence) {
    Class.new {
      attr_accessor :embargo_release_date
    }.new
  }

  subject { model.new }

  before(:each) do
    subject.embargoable_persistence_container = persistence
  end

  context 'visibility' do
    let(:the_date) { 2.days.from_now }
    it "should return the 'open' value when embargo isn't set" do
      expect(subject.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    it "should return the 'open_with_embargo_release_date' value when embargo is set" do
      subject.embargo_release_date = the_date
      expect(subject.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_EMBARGO
    end
  end

  context 'validation' do
    it 'is valid without an embargo_release_date' do
      expect(subject.valid?).to eq(true)
    end

    it 'is not valid with a past embargo date' do
      subject.embargo_release_date = 2.days.ago.to_s
      expect(subject.valid?).to eq(false)
    end
  end

  context 'persistence' do
    let(:the_date) { 2.days.from_now }

    it 'persists a date object' do
      subject.embargo_release_date = the_date
      expect {
        subject.save
      }.to change(persistence, :embargo_release_date).from(nil).to(the_date.to_date)
    end

    it 'persists a valid string' do
      subject.embargo_release_date = the_date.to_s
      expect {
        subject.save
      }.to change(persistence, :embargo_release_date).from(nil).to(the_date.to_date)
    end

    it 'persists an empty string' do
      subject.embargo_release_date = ''
      expect {
        subject.save
      }.to_not change(persistence, :embargo_release_date)
    end

    it 'does not persist an invalid string' do
      subject.embargo_release_date = "Tim"
      expect {
        expect(subject.save).to eq(false)
      }.to_not change(persistence, :embargo_release_date)
    end
  end

end
