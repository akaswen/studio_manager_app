class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def wait_list_email
    @user = params[:user]
    mail(to: @user.email, subject: "Status Change")
  end

  def add_to_studio_email
    @user = params[:user]
    mail(to: @user.email, subject: "Status Change")
  end
end
