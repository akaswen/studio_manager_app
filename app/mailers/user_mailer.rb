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
end
