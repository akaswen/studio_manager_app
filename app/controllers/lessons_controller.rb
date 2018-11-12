class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_active_user
  #before_action :authenticate_teacher
  before_action :redirect_non_student_teacher 

  def new
  end

  private

  def redirect_non_student_teacher
    redirect_to root_path unless current_user.student || current_user.teacher
  end
end

