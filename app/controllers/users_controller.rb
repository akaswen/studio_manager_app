class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]
  before_action :authenticate_teacher, only: [:wait_list, :add_student]

  def dashboard
    @user = current_user
    @new_students = User.where(status: 'Pending').all if current_user.teacher
  end

  def wait_list
    r = JSON.load(request.body)
    id = r["id"]
    @user = User.find(id)
    @user.update_attribute(:status, "Wait Listed")
  end

  def add_student
    r = JSON.load(request.body)
    id = r["id"]
    @user = User.find(id)
    @user.update_attribute(:student, true)
    @user.update_attribute(:status, nil)
  end

  private

  def redirect_from_dashboard
    redirect_to home_path unless user_signed_in?
  end

  def authenticate_teacher
    redirect_to home_path unless current_user.teacher
  end
end
