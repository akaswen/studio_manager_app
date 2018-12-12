require 'rails_helper'

RSpec.feature "CreateAndEditProfiles", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @teacher = create(:teacher)
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it("allows a user to create a profile") do
    visit new_user_registration_path
    fill_in('First name', with: "Robert")
    fill_in('Last name', with: "George")
    fill_in('Email', with: 'aaron10@example.com')
    fill_in('Password', with: 'Password2')
    fill_in('Password confirmation', with: 'Password2')
    fill_in('Street address', with: '50 summer ln')
    fill_in('City', with: 'Las Vegas')
    select('NV', from: 'State')
    fill_in('Zip code', with: '00000')
    fill_in('Phone number', with: '111 111 1111')
    select('Home', from: 'Kind')
    fill_in('Password', with: 'Password1')
    fill_in('Password confirmation', with: 'Password1')
    expect{
      click_button('Sign up')
    }.to change{ User.count }.by(1).and change{ ActionMailer::Base.deliveries.length }.by(1)
  end
  
  it("allows a user to edit their own profile") do
    sign_in(@user)
    click_link('Edit Profile')
    within('#user_form') do
      fill_in('First name', with: "Robert")
      fill_in('Last name', with: "George")
      fill_in('Email', with: 'aaron10@example.com')
      fill_in('Password', with: 'Password2')
      fill_in('Password confirmation', with: 'Password2')
      fill_in('Street address', with: '50 summer ln')
      fill_in('City', with: 'Las Vegas')
      select('NV', from: 'State')
      fill_in('Zip code', with: '00000')
      fill_in('Phone number', with: '111 111 1111')
      select('Home', from: 'Kind')
      fill_in('Current password', with: 'Password1')
    end
    click_button('Update')
    sign_out(@user)
    visit new_user_session_path
    fill_in('Email', with: 'aaron10@example.com')
    fill_in('Password', with: 'Password2')
    click_button('Log in')
    expect(page).to have_content('Robert George')
    @user.reload
    @address = @user.address
    @phone = @user.phone_number
    expect(@address.street_address).to eq('50 summer ln')
    expect(@address.city).to eq('Las Vegas')
    expect(@address.state).to eq('NV')
    expect(@address.zip_code).to eq('00000')
    expect(@phone.number).to eq('1111111111')
    expect(@phone.kind).to eq('home')
  end
end
