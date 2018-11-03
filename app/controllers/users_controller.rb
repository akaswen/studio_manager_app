class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]
  before_action :authenticate_teacher, only: [:update_status]

  def dashboard
    @user = current_user
    @new_students = User.where(status: 'Pending').all if current_user.teacher
  end

  def update_status
    @user = User.find(params[:id])
    @user.update_attribute(:status, params[:status])
  end

  private

  def redirect_from_dashboard
    redirect_to home_path unless user_signed_in?
  end

  def authenticate_teacher
    redirect_to home_path unless current_user.teacher
  end
end
