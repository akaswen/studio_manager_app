require 'rails_helper'

RSpec.feature "WaitListings", type: :feature do
  before(:each) do
    @teacher = create(:teacher)
    @user = create(:user)
    @user.confirm
    ActionController::Base.allow_forgery_protection = true
  end

  xit('allows teacher to wait-list non-students', js: true) do
    sign_in(@user)
    expect(page).to have_content("Pending")
    find('#icon').click
    sign_out(@user)
    sign_in(@teacher)
    within("#teacher-sidebar") do
      find('#new_student_toggle').click
      expect(page).to_not have_content(@teacher.full_name)
      expect(page).to have_content(@user.full_name)
      within("li[id='#{@user.id}']") do
        click_button('Wait List')
      end
    expect(page).to_not have_content(@user.full_name)
    end
    click_link('Wait List')
    expect(page).to have_content(@user.full_name)
    find('#icon').click
    sign_out(@teacher)
    sign_in(@user)
    expect(page).to_not have_content("Pending")
    expect(page).to have_content("Wait Listed")
  end

  xit('allows teacher to add non-student to studio', js: true) do
    expect(@user.student).to eq(false)
    sign_in(@teacher)
    within("#teacher-sidebar") do
      find('#new_student_toggle').click
      expect(page).to_not have_content(@teacher.full_name)
      expect(page).to have_content(@user.full_name)
      within("li[id='#{@user.id}']") do
        click_button('Studio')
      end
    expect(page).to_not have_content(@user.full_name)
    end
    click_link('Studio')
    expect(page).to have_content(@user.full_name)
  end
end
