class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]
  before_action :authenticate_active_user
  before_action :authenticate_teacher, only: [:wait_list, :add_student, :index, :show]
  before_action :param_check, only: [:index]

  def index
    @users = User.where("status = ? OR student = ?", params[:status], params[:student])
    @title = params[:status] ? "Wait List": "Studio List"
  end

  def show
    @user = User.find(params[:id])
    @address = @user.addresses.first
    @phone_number = @user.phone_numbers.first
    @teacher_address = current_user.addresses.first
  end

  def destroy
    @user = User.find(params[:id])
    if current_user == @user || current_user.teacher
      @user.update_attribute(:active, false)
      UserMailer.with(user: @user).deactivation_email.deliver_now
    else 
      redirect_to root_path
    end
  end

  def dashboard
    @user = current_user
    @new_students = User.confirmed.where(status: 'Pending').all if current_user.teacher
  end

  def wait_list
    r = JSON.load(request.body)
    id = r["id"]
    @user = User.find(id)
    @user.update_attribute(:status, "Wait Listed")
    UserMailer.with(user: @user).wait_list_email.deliver_now
  end

  def add_student
    r = JSON.load(request.body)
    id = r["id"]
    @user = User.find(id)
    @user.update_attribute(:student, true)
    @user.update_attribute(:status, nil)
    UserMailer.with(user: @user).add_to_studio_email.deliver_now
  end

  private

  def redirect_from_dashboard
    redirect_to home_path unless user_signed_in?
  end

  def authenticate_teacher
    redirect_to root_path unless current_user.teacher
  end

  def param_check
    unless params[:student] == 'true' || params[:status] == 'Wait Listed'
      redirect_to root_path
    end
  end

  def authenticate_active_user
    unless current_user.active?
      redirect_to new_user_session_path
    end
  end
end
