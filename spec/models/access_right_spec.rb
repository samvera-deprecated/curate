require 'spec_helper'

describe AccessRight do
  [
    [false, AccessRight::PERMISSION_TEXT_VALUE_PUBLIC, nil, true, false, false],
    [false, AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED, nil, false, true, false],
    [false, nil, nil, false, false, true],
    [false, nil, AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC, true, false, false],
    [false, nil, AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED, false, true, false],
    [false, nil, AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE, false, false, true],
  ].each do |given_persisted, givin_permission, given_visibility, expected_open_access, expected_authentication_only, expected_private|
    spec_text = <<-TEXT

    EXPECTED: {
      open_access: #{expected_open_access},
      restricted: #{expected_authentication_only},
      private: #{expected_private}
    },
    GIVEN: {
      persisted: #{given_persisted},
      permission: #{givin_permission},
      visibility: #{given_visibility}
    }
    TEXT

    it spec_text do
      permissions = [{access: :edit, name: givin_permission}]
      permissionable = double(
        'permissionable',
        permissions: permissions,
        visibility: given_visibility,
        persisted?: given_persisted
      )
      access_right = AccessRight.new(permissionable)

      expect(access_right.open_access?).to eq(expected_open_access)
      expect(access_right.authenticated_only?).to eq(expected_authentication_only)
      expect(access_right.private?).to eq(expected_private)
    end
  end
end
