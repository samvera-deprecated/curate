class WelcomeController < ApplicationController
  with_themed_layout '2_column'

  before_filter :authenticate_user!, only: :new

  respond_to :html
  def index
    respond_with
  end

  def new
    if first_time_login?
      redirect_to new_classify_concern_path
    end
    redirect_to dashboard_index_path
  end

  private

  def show_action_bar?
    false
  end

  def first_time_login?
    user_login_count > 1 ? false : true
  end

  def user_login_count
    current_user.sign_in_count
  end
end
