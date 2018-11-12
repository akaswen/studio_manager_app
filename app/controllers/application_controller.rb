class ApplicationController < ActionController::Base

  private

  def authenticate_teacher
    redirect_to root_path unless current_user.teacher
  end

  def authenticate_active_user
    unless current_user.active?
      redirect_to new_user_session_path
    end
  end
end
