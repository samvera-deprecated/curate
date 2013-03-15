require 'spec_helper'

describe EmbargoValidator do
  let(:pid) { CurationConcern.mint_a_pid }
  let(:user) { FactoryGirl.create(:user) }
  let(:curation_concern) { SeniorThesis.new(pid: pid)}

  subject {
    curation_concern
  }

  describe '#embargo date validation' do
    let(:embargo_release_date) {
      Date.today.to_s
      }

    it "should error out embargo date" do
      subject.embargo_release_date = embargo_release_date
      subject.save!
      subject.rightsMetadata.embargo_release_date.should == release_date
    end
  end
  #Old code reference to start with
  #describe 'invalid embargo date'do
  #  before(:each) do
  #    subject.create!
  #  end
  #  describe 'should assign not embargo date'do
  #    let(:attributes) {
  #      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
  #        a[:release_date] = Date.today.to_s
  #      }
  #    }
  #    it  do
  #      expect(curation_concern).to be_persisted
  #      puts "Attributes:#{attributes.inspect} ,Release date:#{curation_concern.rightsMetadata.embargo_release_date.inspect}"
  #      curation_concern.release_date.should be_nil
  #    end
  #  end
  #  describe "should assign not embargo date since it is string" do
  #    let(:attributes) {
  #      FactoryGirl.attributes_for(:senior_thesis).tap {|a|
  #        a[:release_date] = "release_date"
  #      }
  #    }
  #    it do
  #      expect(curation_concern).to be_persisted
  #      puts "Attributes:#{attributes.inspect} ,Release date:#{curation_concern.rightsMetadata.embargo_release_date.inspect}"
  #      curation_concern.release_date.should be_nil
  #    end
  #  end
  #end
end