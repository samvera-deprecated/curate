class ContentLicense
  def initialize( current_user )
    @user = current_user
  end

  def is_permitted?(licensing_permission = LICENSING_PERMISSIONS.fetch( 'licensing_permissions' ))
    begin
      open_to = licensing_permission.fetch( 'open' ) { 'nobody' }
      case open_to
        when 'all' then true
        when 'nobody' then false
        else @user.groups.include?( open_to )
      end
    rescue KeyError
      false
    end
  end
end
