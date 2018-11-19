class LessonsController < ApplicationController
  include LessonsHelper
  before_action :authenticate_user!
  before_action :authenticate_active_user
  before_action :redirect_non_student_teacher 
  before_action :day_before_check, only: [:destroy]
  before_action :create_params_check, only: [:create]

  def new
    @schedule = User.teacher.schedule
    case params["week"]
    when "2"
      @week = beginning_of_week + 1.week
    when "3"
      @week = beginning_of_week + 2.weeks
    when "4"
      @week = beginning_of_week + 3.weeks
    else
      @week = beginning_of_week
    end
      @weeks_lessons = Lesson.week(@week)
  end

  def create
    n = params["occurence"] == "weekly" ? 4 : 1
    lessons = []
    
    n.times do |i|
      start_time = DateTime.parse(params["time"]) + i.weeks
      end_time = start_time + params["length"].to_i.minutes
      location = params["location"]
      student = User.find_by(id: params["id"]) || current_user
      teacher = User.teacher

      lesson = Lesson.new(start_time: start_time, end_time: end_time, location: location, student_id: student.id, teacher_id: teacher.id)

      lesson.repeat = true  if i == 3

      lesson.confirmed = true if current_user.teacher

      raise "Slot on #{start_time} is already taken" unless lesson.valid?
      lessons << lesson
    end

    lessons.each { |l| l.save }

    UserMailer.with(user: User.teacher, lessons: lessons).lesson_request_email.deliver_now unless current_user.teacher
  end

  def update
    lesson = Lesson.find(params["id"])
    lesson.update_attribute(:confirmed, true)

    if params["occurence"] == "weekly"
      3.times do |n|
        other_lesson = Lesson.find_by(start_time: lesson.start_time + (n + 1).weeks)
        other_lesson.update_attribute(:confirmed, true)
      end
    end

    UserMailer.with(lesson: lesson, occurence: params["occurence"]).lesson_confirmation_email.deliver_now
  end

  def destroy
    lesson = Lesson.find(params["id"])
    if current_user == lesson.student || current_user.teacher
      if params["destroy_all"] == "true"
        future_lesson_times = []
        6.times do |n|
          future_lesson_times << lesson.start_time + n.weeks
        end
        other_lessons = Lesson.where(start_time: future_lesson_times, student: lesson.student).all
        other_lessons.destroy_all
      else
        if lesson.repeat
          new_lesson = Lesson.new(start_time: lesson.start_time + 1.week, end_time: lesson.end_time + 1.week, location: lesson.location, student_id: lesson.student.id, teacher_id: lesson.teacher.id)
          new_lesson.save

          lesson.destroy
        else
          lesson.destroy
        end
      end
      UserMailer.with(lesson: lesson, destroy_all: params["destroy_all"]).lesson_deletion_email.deliver_now
    end
  end

  private

  def redirect_non_student_teacher
    redirect_to root_path unless current_user.student || current_user.teacher
  end

  def day_before_check
    lesson = Lesson.find(params["id"])
    unless lesson.start_time > Time.now + 24.hours || current_user.teacher
      redirect_to root_path
      flash["alert"] = "you cannot cancel a lesson within 24 hours"
    end
  end

  def create_params_check
    if params["id"] && params["id"] != "null"
      redirect_to root_path unless current_user.teacher
    end
  end
end

