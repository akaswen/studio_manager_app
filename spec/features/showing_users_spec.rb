require 'rails_helper'

RSpec.feature "ShowingUsers", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @student = create(:student)
    @teacher = create(:teacher)
    sign_in(@teacher)
    ActionController::Base.allow_forgery_protection = true
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
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

  it("allows a teacher to deactivate a new account or add to wait list or studio") do
    visit user_path(@user)
    expect(page).to have_button('Deactivate Student') #test for this is in deactivating account feature spec
    expect(page).to have_button('Add to Studio')
    expect(page).to have_button('Wait List')
  end

  it('allows a teacher to deactivate or add to studio a wait listed student') do
    @user.update_attribute(:status, "Wait Listed")
    visit user_path(@user)
    expect(page).to have_button('Deactivate Student')
    expect(page).to have_button('Add to Studio')
    expect(page).to_not have_button('Wait List')
  end

  it('can add a student to studio', js: true) do
    visit user_path(@user)
    click_button('Add to Studio')
    expect(page).to have_content('Studio List')
    expect(page).to have_link(@user.full_name)
  end

  it('can add a student to the wait list', js: true) do
    visit user_path(@user)
    click_button('Wait List')
    expect(page).to have_text('Wait List')
    expect(page).to have_link(@user.full_name)
  end

  it('allows a teacher to deactivate a current student') do
    visit user_path(@student) 
    expect(page).to have_button('Deactivate Student')
    expect(page).to_not have_button('Add to Studio')
    expect(page).to_not have_button('Wait List')
  end

  fit('allows a teacher to set rates for students', js:true) do
    visit user_path(@student)
    expect(page).to have_content(@student.rate)
    click_button('Adjust')
    fill_in('Rate per Hour', with: 50)
    click_button('change')
    expect(page).to have_content('$50/h')
    visit user_path(@student)
    expect(page).to have_content('$50/h')
  end

  it("doesn't display a rate for a non-student") do
  end
end
