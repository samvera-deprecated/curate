module FeatureSupport
  def login_as(user)
    user.reload # because the user isn't re-queried via Warden
    super(user, scope: :user, run_callbacks: false)
  end
end
