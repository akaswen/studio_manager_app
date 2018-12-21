class UsersController < ApplicationController
  before_action :redirect_from_dashboard, only: [:dashboard]
  before_action :authenticate_user!, except: [:dashboard]
  before_action :authenticate_active_user
  before_action :authenticate_teacher, only: [:wait_list, :add_student, :index, :show]
  before_action :param_check, only: [:index]
  before_action :authenticate_teacher_or_self, only: [:destroy]

  def index
    if params[:status]
      @title = "Wait List"
      @users = User.active.where(status: params[:status]).order(:created_at)
    else
      @title = "Studio List"
      @users = User.active.where(student: params[:student]).order(:first_name)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @location = request.env["HTTP_REFERER"]
    @user = User.find(params[:id])
    if @user.teacher
      redirect_to root_path
    else
      @address = @user.address
      @phone_number = @user.phone_number
      @teacher_address = current_user.address
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:active, false)
    @user.learning_lessons.where("start_time > ?", Time.now).destroy_all
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
    if current_user.teacher
      @new_students = User.confirmed.active.where(status: 'Pending').all
      @weekly_lesson_requests = Lesson.initial_of_repeating
      query_params = []
      4.times do |n|
        @weekly_lesson_requests.each { |l| query_params << l.start_time + n.weeks }
      end
      @single_lesson_requests = Lesson.where.not(confirmed: true, start_time: query_params).where("start_time > ?", Time.now)
      @payment = Payment.new
      @students = User.active.where(student: true).order(:last_name).all
      @todays_lessons = Lesson.where(confirmed: true, start_time: (Time.now.beginning_of_day..Time.now.end_of_day))
      @next_weeks_lessons = Lesson.where(confirmed: true, start_time: (Time.now.end_of_day..Time.now.beginning_of_day + 1.week)).paginate(page: params[:page], per_page: 5)
      @unpaid_lessons = Lesson.where("confirmed = ? AND paid = ? AND end_time < ?", true, false, Time.now).all
    else 
      @lessons = Lesson.where("confirmed = ? AND student_id = ? AND start_time > ?", true, current_user.id, Time.now).to_a
      @next_lesson = @lessons.shift
    end
  end

  def wait_list
    @user = User.find(params["id"])
    @user.update_attribute(:status, "Wait Listed")
    UserMailer.with(user: @user).wait_list_email.deliver_now
  end

  def add_student
    raise "requires a rate per hour" unless params["rate"]
    @user = User.find(params["id"])
    if @user.student
      old_rate = @user.rate_per_hour
      UserMailer.with(user: @user, old_rate: old_rate, new_rate: params["rate"]).update_rate_email.deliver_now
    else
      @user.update_attribute(:student, true)
      @user.update_attribute(:status, nil)
      UserMailer.with(user: @user, rate: params["rate"]).add_to_studio_email.deliver_now
    end
    @user.update_attribute(:rate_per_hour, params["rate"])
  end

  private

  def redirect_from_dashboard
    redirect_to home_path unless user_signed_in?
  end

  def param_check
    unless params[:student] == 'true' || params[:status] == 'Wait Listed'
      redirect_to root_path
    end
  end

  def authenticate_teacher_or_self
    @user = User.find(params[:id])
    unless @user == current_user || current_user.teacher
      redirect_to root_path
    end
  end
end
