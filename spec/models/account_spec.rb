require 'spec_helper'

describe Account do
  let(:name) { 'Bilbo Baggins' }
  let(:user) { FactoryGirl.build(:user) }
  subject { Account.new(user) }

  its(:inspect) { should include("#<Account user.id: #{user.id}, user.repository_id: #{user.repository_id}") }

  describe 'class methods' do
    subject { Account }
    its(:inspect) { should match /\AAccount/ }

    describe '.attribute_names' do
      subject { Account.attribute_names }
      its(:length) { should be > 5}
    end

    describe '.new_with_session' do
      let(:attributes) { { name: name } }
      let(:session) { {} }
      subject { Account.new_with_session(attributes, session) }
      its(:name) { should == name }
      it { should be_kind_of Account }
    end

    describe '.to_adapter.get!' do
      let(:user) { FactoryGirl.create(:user) }
      subject { Account.to_adapter.get!(user.to_key) }
      its(:user) { should == user }
      it { should be_kind_of Account }
    end

  end

  describe '#update_with_password' do
    let(:password) { 'a password' }
    let(:user) { subject.user }
    let(:person) { user.person }
    let(:alternate_email) { 'somewhere@not-here.com'}
    subject { FactoryGirl.create(:account) }

    context 'without person or profile' do

      let(:password) { 'password' }
      let(:user) { FactoryGirl.create(:user, password: password, password_confirmation: password) }
      let(:attributes) { {current_password: password} }
      subject { Account.new(user) }

      it 'should create a person and profile' do
        expect(user.profile).to be_nil
        expect(user.person).to_not be_persisted

        subject.update_with_password(attributes)

        user.reload
        expect(user.person.persisted?).to be_truthy
        expect(user.profile.persisted?).to be_truthy
      end

    end

    describe 'with valid attributes' do
      it 'should update the user' do
        expect {
          expect {
            subject.update_with_password(current_password: password, alternate_email: alternate_email)
          }.to change(user, :alternate_email).to(alternate_email)
        }.to change(person, :alternate_email).to(alternate_email)
      end

      it 'if the person name changes, it keeps profile title in sync' do
        new_name = 'Meriadoc Brandybuck'
        subject.update_with_password(current_password: password, name: new_name)
        person.name.should == new_name
        person.profile.reload
        person.profile.title.should == new_name
      end

      it 'if the person name changes, it keeps the user.name in sync' do
        new_name = 'Meriadoc Brandybuck'
        subject.update_with_password(current_password: password, name: new_name)
        person.name.should == new_name
        person.user.name.should == new_name
      end
    end

    describe 'with invalid attributes' do
      it 'should update the user' do
        expect {
          expect {
            subject.update_with_password(current_password: password*2, alternate_email: alternate_email)
          }.to_not change(user, :alternate_email)
        }.to_not change(person, :alternate_email)

        expect(subject.errors).to_not be_empty
      end
    end
  end

  describe '#save via .new_with_session' do
    let(:expected_name) { 'Robert Frost' }
    let(:attributes) { FactoryGirl.attributes_for(:user, name: expected_name) }
    let(:session) { {} }

    subject { Account.new_with_session(attributes, session) }
    describe 'valid attributes' do
      it 'should create a user, person, and profile' do
        expect {
          expect {
            expect {
              subject.save
            }.to change(User, :count).by(1)
          }.to change(Person, :count).by(1)
        }.to change(Profile, :count).by(1)

        user = subject.user.reload
        expect(user.name).to eq(expected_name)
        expect(user.person).to be_persisted
        expect(user.person).to eq(subject.person)

        expect(subject.person.read_groups).to include(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC)
        expect(subject.person.edit_users).to include(user.user_key)
        expect(subject.person.depositor).to eq user.user_key
        expect(subject.person.name).to eq expected_name

        expect(subject.profile.read_groups).to include(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC)
        expect(subject.profile.edit_users).to include(user.user_key)
        expect(subject.profile.depositor).to eq user.user_key
        expect(subject.profile.title).to eq expected_name
      end
    end

    describe 'invalid attributes' do
      let(:attributes) { FactoryGirl.attributes_for(:user).merge(password: 'a valid password', password_confirmation: 'an invalid password') }
      let(:session) { {} }

      subject { Account.new_with_session(attributes, session) }

      it 'should not create a user even if the user is valid but the person is not' do
        expect {
          expect {
            expect {
              subject.save
            }.to_not change(User, :count)
          }.to_not change(Person, :count)
        }.to_not change(Profile, :count)
        expect(subject.errors).to_not be_empty
      end
    end
  end

  describe 'a user with no name' do
    let(:user) { FactoryGirl.build(:user) }
    subject { Account.new(user) }

    it 'has a default title for the profile' do
      subject.name.should == user.name
      subject.profile.title.should == user.name
    end
  end

  describe 'factories', factory_verification: true do
    describe '.build' do
      it 'should not persist' do
        account = FactoryGirl.build(:account)
        expect(account.user).to_not be_persisted
        expect(account.person).to_not be_persisted
        expect(account.profile).to_not be_persisted
      end
    end

    describe '.create' do
      it 'should persist' do
        account = FactoryGirl.create(:account)
        user = User.find(account.user.id)
        expect(account.user).to eq user
        expect(account.person).to eq user.person
        expect(account.profile).to eq user.person.profile
      end
    end
  end
end
