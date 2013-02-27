require 'spec_helper'
require "cancan/matchers"

describe "User" do
  describe "Abilities" do
    subject { ability }
    let(:ability) { Ability.new(current_user) }
    let(:senior_thesis) { FactoryGirl.create_curation_concern(:senior_thesis, creating_user) }
    let(:creating_user) { nil }
    let(:current_user) { nil }
    let(:user) { FactoryGirl.create(:user) }

    describe 'creator of object' do
      let(:creating_user) { user }
      let(:current_user) { user }
      it { should be_able_to(:create, SeniorThesis.new) }
      it { should be_able_to(:read, senior_thesis) }
      it { should be_able_to(:update, senior_thesis) }
      it { should_not be_able_to(:delete, senior_thesis) }
    end

    describe 'another authenticated user' do
      let(:creating_user) { FactoryGirl.create(:user) }
      let(:current_user) { user }
      it { should be_able_to(:create, SeniorThesis.new) }
      it { should_not be_able_to(:read, senior_thesis) }
      it { should_not be_able_to(:update, senior_thesis) }
      it { should_not be_able_to(:delete, senior_thesis) }
    end

    describe 'a nil user' do
      let(:creating_user) { FactoryGirl.create(:user) }
      let(:current_user) { nil }
      it { should_not be_able_to(:create, SeniorThesis.new) }
      it { should_not be_able_to(:read, senior_thesis) }
      it { should_not be_able_to(:update, senior_thesis) }
      it { should_not be_able_to(:delete, senior_thesis) }
    end
  end
end
