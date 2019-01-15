class ApplicationController < ActionController::Base

  private

  def authenticate_teacher
    redirect_to root_path unless current_user.teacher
  end
end
