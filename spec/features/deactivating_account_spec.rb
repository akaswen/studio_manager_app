require 'rails_helper'

RSpec.feature "DeactivatingAccounts", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @wait_listed = create(:user, email: "aaron1@example.com", status: "Wait Listed")
    @wait_listed.confirm
    @student = create(:student)
    @teacher = create(:teacher)
    ActionController::Base.allow_forgery_protection = true
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
  end

  it("allows a user to deactivate their account from the edit profile page") do
    sign_in(@user)
    visit edit_user_registration_path(@user)
    click_button('Deactivate Account')
    expect{ @user.reload }.to change{ @user.active }.from(true).to(false)
  end

  it("allows a user to reactivate their account when they sign in again") do
    sign_in(@user)
    visit edit_user_registration_path(@user)
    click_button('Deactivate Account')
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    expect(page).to have_content(@user.full_name)
    @user.reload
    expect(@user.active).to be_truthy
  end

  it("deactivated users aren't shown in any of the teacher's views") do
    sign_in(@teacher)
    expect(page).to have_link(@user.full_name)
    visit users_path(student: true)
    expect(page).to have_link(@student.full_name)
    visit users_path(status: "Wait Listed")
    expect(page).to have_link(@wait_listed.full_name)
    @user.update_attribute(:active, false)
    @student.update_attribute(:active, false)
    @wait_listed.update_attribute(:active, false)
    visit dashboard_path
    expect(page).to_not have_link(@user.full_name)
    visit users_path(student: true)
    expect(page).to_not have_link(@student.full_name)
    visit users_path(status: "Wait Listed")
    expect(page).to_not have_link(@wait_listed.full_name)
  end

  it("deactivation has friendly forwarding for teacher") do
    sign_in(@teacher)
    click_link(@user.full_name)
    click_button('Deactivate Student')
    expect(page).to have_content(@teacher.full_name)
    click_link('Studio')
    click_link(@student.full_name)
    click_button('Deactivate Student')
    expect(page).to have_content("Studio List")
    click_link('Wait List')
    click_link(@wait_listed.full_name)
    click_button('Deactivate Student')
    expect(page).to have_content('Wait List')
    expect(page).to_not have_content(@teacher.full_name)
  end

  it("allows javascript deactivation for teacher", js: true) do
    sign_in(@teacher)
    click_link('Studio')
    within("li[id='#{@student.id}']") do
      click_button('Deactivate')
    end
    expect(page).to have_content('Studio List')
    expect(page).to_not have_link(@student.full_name)
    click_link('Wait List')
    click_link('Studio')
    expect(page).to_not have_link(@student.full_name)
  end
end
