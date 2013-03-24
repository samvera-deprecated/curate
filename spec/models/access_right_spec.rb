require 'spec_helper'

describe AccessRight do
  let(:permissionable) {
    double('permissionable', permissions: permissions, visibility: visibility)
  }
  let(:permissions) { [{access: :edit, name: permission_name}] }
  let(:permission_name) { nil }
  let(:visibility) { nil }
  subject { AccessRight.new(permissionable) }

  describe 'with #visibility not set' do
    let(:visibility) { nil }
    describe 'open_access?' do
      let(:permission_name) { AccessRight::PERMISSION_TEXT_VALUE_PUBLIC }
      it { expect(subject).to be_open_access }
    end

    describe 'authenticated_only?' do
      let(:permission_name) { AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED }
      it { expect(subject).to be_authenticated_only }
    end

    describe 'private?' do
      let(:permission_name) { nil }
      it { expect(subject).to be_private }
    end
  end

  describe 'with #visibility set' do
    let(:permission_name) { nil }
    describe 'open_access?' do
      let(:visibility) { AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
      it { expect(subject).to be_open_access }
    end

    describe 'authenticated_only?' do
      let(:visibility) { AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      it { expect(subject).to be_authenticated_only }
    end

    describe 'private?' do
      let(:visibility) { AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      it { expect(subject).to be_private }
    end
  end
end
