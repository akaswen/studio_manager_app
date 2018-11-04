require 'rails_helper'

RSpec.feature "ShowingUsers", type: :feature, focus: true do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @student = create(:student)
    @teacher = create(:teacher)
    sign_in(@teacher)
  end

  it("allows a teacher to see a user's profile from the dashboard") do
    within('#teacher-sidebar') do
      click_link(@user.full_name)
    end
    @address = @user.addresses.first
    @phone = @user.phone_numbers.first
    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@address.street_address)
    expect(page).to have_content(@address.city)
    expect(page).to have_content(@address.state)
    expect(page).to have_content(@address.zip_code)
    expect(page).to have_content(@phone.pretty_number)
    expect(page).to have_content(@phone.kind)
  end

  it("allows a teacher to see a user's profile from the wait list") do
    @user.update_attribute(:status, "Wait Listed")
    click_link('Wait List')
    click_link(@user.full_name)
    @address = @user.addresses.first
    @phone = @user.phone_numbers.first
    expect(page).to have_content(@user.full_name)
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@address.street_address)
    expect(page).to have_content(@address.city)
    expect(page).to have_content(@address.state)
    expect(page).to have_content(@address.zip_code)
    expect(page).to have_content(@phone.pretty_number)
    expect(page).to have_content(@phone.kind)
  end

  it("allows a teacher to see a user's profile from the studio") do
    click_link('Studio')
    click_link(@student.full_name)
    @address = @student.addresses.first
    @phone = @student.phone_numbers.first
    expect(page).to have_content(@student.full_name)
    expect(page).to have_content(@student.email)
    expect(page).to have_content(@address.street_address)
    expect(page).to have_content(@address.city)
    expect(page).to have_content(@address.state)
    expect(page).to have_content(@address.zip_code)
    expect(page).to have_content(@phone.pretty_number)
    expect(page).to have_content(@phone.kind)
  end
end
