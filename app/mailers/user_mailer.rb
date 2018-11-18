class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def wait_list_email
    @user = params[:user]
    mail(to: @user.email, subject: "Status Change")
  end

  def add_to_studio_email
    @user = params[:user]
    @rate = params[:rate]
    mail(to: @user.email, subject: "Status Change")
  end

  def deactivation_email
    @user = params[:user]
    mail(to: @user.email, subject: "Account deactivated")
  end

  def update_rate_email
    @user = params[:user]
    @old_rate = params[:old_rate]
    @new_rate = params[:new_rate]
    mail(to: @user.email, subject: "Rate Changed")
  end

  def lesson_request_email
    @user = params[:user]
    @lessons = params[:lessons]
    mail(to: @user.email, subject: "New lesson request from #{@lessons[0].student.full_name}")
  end

  def lesson_confirmation_email
    @lesson = params[:lesson]
    @user = @lesson.student
    @occurence = params[:occurence]
    mail(to: @user.email, subject: "Lesson confirmed")
  end

  def lesson_deletion_email
    @lesson = params[:lesson]
    @teacher = @lesson.teacher
    @student = @lesson.student
    @destroy_all = params[:destroy_all]
    mail(to: @student.email, bcc: @teacher.email, subject: "lesson cancelation")
  end
end
