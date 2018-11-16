class LessonsController < ApplicationController
  include LessonsHelper
  before_action :authenticate_user!
  before_action :authenticate_active_user
  #before_action :authenticate_teacher
  before_action :redirect_non_student_teacher 

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
    # getting attributes for new lesson
    start_time = DateTime.parse(params["time"])
    end_time = start_time + params["length"].to_i.minutes
    location = params["location"]
    student = current_user
    teacher = User.teacher

    n = params["occurence"] == "weekly" ? 4 : 1

    n.times do |i|
      lesson = Lesson.new(start_time: start_time, end_time: end_time, location: location)
      lesson.student = student
      lesson.teacher = teacher

      start_time += 1.week
      end_time += 1.week
      lesson.repeat = true  if i == 3

      lesson.save
    end
  end

  private

  def redirect_non_student_teacher
    redirect_to root_path unless current_user.student || current_user.teacher
  end
end

