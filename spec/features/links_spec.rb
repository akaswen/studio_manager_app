require 'rails_helper'

RSpec.feature "Links", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @student = create(:student)
    @teacher = create(:teacher)
  end


  describe "links not logged in" do
    it "has correct links not logged in" do
      visit home_path
      expect(page).to have_link("Welcome", href: home_path)
      expect(page).to have_link("About", href: about_path)
      expect(page).to have_link("Sign in", href: new_user_session_path)
      expect(page).to have_link("Sign up", href: new_user_registration_path)
      expect(page).to_not have_link("Sign out", href: destroy_user_session_path)
      expect(page).to_not have_link("Dashboard", href: dashboard_path)
      expect(page).to_not have_link("Edit Profile", href: edit_user_registration_path)
      expect(page).to_not have_link("Studio", href: users_path(student: true))
      expect(page).to_not have_link("Wait List", href: users_path(status: 'Wait Listed'))
      expect(page).to_not have_link("Schedule", href: schedule_path)
      expect(page).to_not have_link("Payment History", href: payments_path)
    end 
  end

  describe "links logged in" do
    it('has correct links logged in for a non-student') do
      sign_in(@user)
      expect(page).to have_link('Welcome', href: home_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to_not have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign up", href: new_user_registration_path)
      expect(page).to have_link("Sign out", href: destroy_user_session_path)
      expect(page).to have_link("Dashboard", href: dashboard_path)
      expect(page).to have_link("Edit Profile", href: edit_user_registration_path)
      expect(page).to_not have_link("Studio", href: users_path(student: true))
      expect(page).to_not have_link("Wait List", href: users_path(status: 'Wait Listed'))
      expect(page).to_not have_link("Schedule", href: schedule_path)
      expect(page).to_not have_link("Lessons", href: new_lesson_path)
      expect(page).to_not have_link("Payment History", href: payments_path)
    end

    it('has correct links for a student logged in') do
      sign_in(@student)
      expect(page).to have_link('Welcome', href: home_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to_not have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign up", href: new_user_registration_path)
      expect(page).to have_link("Sign out", href: destroy_user_session_path)
      expect(page).to have_link("Dashboard", href: dashboard_path)
      expect(page).to have_link("Edit Profile", href: edit_user_registration_path)
      expect(page).to_not have_link("Studio", href: users_path(student: true))
      expect(page).to_not have_link("Wait List", href: users_path(status: 'Wait Listed'))
      expect(page).to_not have_link("Schedule", href: schedule_path)
      expect(page).to have_link("Lessons", href: new_lesson_path)
      expect(page).to_not have_link("Payment History", href: payments_path)
   end

    it('has correct links for teacher logged in') do
      sign_in(@teacher)
      expect(page).to have_link('Welcome', href: home_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to_not have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign up", href: new_user_registration_path)
      expect(page).to have_link("Sign out", href: destroy_user_session_path)
      expect(page).to have_link("Dashboard", href: dashboard_path)
      expect(page).to have_link("Edit Profile", href: edit_user_registration_path)
      expect(page).to have_link("Studio", href: users_path(student: true))
      expect(page).to have_link("Wait List", href: users_path(status: 'Wait Listed'))
      expect(page).to have_link("Schedule", href: schedule_path)
      expect(page).to have_link("Lessons", href: new_lesson_path)
      expect(page).to have_link("Payment History", href: payments_path)
    end
  end

end
