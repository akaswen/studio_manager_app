class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]
  before_action :authenticate_active_user
  before_action :authenticate_teacher, only: [:wait_list, :add_student, :index, :show]
  before_action :param_check, only: [:index]
  before_action :authenticate_teacher_or_self, only: [:destroy]

  def index
    @users = User.active.where("status = ? OR student = ?", params[:status], params[:student])
    if params[:status]
      @title = "Wait List"
      @users = User.active.where("status = ? OR student = ?", params[:status], params[:student]).order(:created_at)
    else
      @title = "Studio List"
      @users = User.active.where("status = ? OR student = ?", params[:status], params[:student]).order(:first_name)
    end
  end

  def show
    @location = request.env["HTTP_REFERER"]
    @user = User.find(params[:id])
    if @user.teacher
      redirect_to root_path
    else
      @address = @user.addresses.first
      @phone_number = @user.phone_numbers.first
      @teacher_address = current_user.addresses.first
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:active, false)
    UserMailer.with(user: @user).deactivation_email.deliver_now
    if current_user == @user
      sign_out(@user)
      redirect_to home_path
    elsif params[:redirect]
      redirect_to params[:redirect]
    end
  end

  def dashboard
    @user = current_user
    @new_students = User.confirmed.active.where(status: 'Pending').all if current_user.teacher
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
    rate = r["rate"]
    @user = User.find(id)
    @user.update_attribute(:student, true)
    @user.update_attribute(:status, nil)
    @user.update_attribute(:rate_per_hour, rate)
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

  def authenticate_teacher_or_self
    @user = User.find(params[:id])
    unless @user == current_user || current_user.teacher
      redirect_to root_path
    end
  end
end
