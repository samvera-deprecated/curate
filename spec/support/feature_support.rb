module FeatureSupport
  def with_javascript?
    @example.metadata[:js] || @example.metadata[:javascript]
  end
  def login_as(user)
    user.reload # because the user isn't re-queried via Warden
    super(user, scope: :user, run_callbacks: false)
  end
  def logout(user=:user)
    super(user)
  end
end
