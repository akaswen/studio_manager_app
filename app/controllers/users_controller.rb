class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]

  def dashboard
    @user = current_user
  end

  private

  def redirect_from_dashboard
    redirect_to home_path unless user_signed_in?
  end

end
