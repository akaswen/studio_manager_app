require 'rails_helper'

RSpec.feature "WaitListings", type: :feature do
  before(:each) do
    @teacher = create(:teacher)
    @user = create(:user)
    @user.confirm
  end

  it('allows teacher to wait-list non-students') do
    sign_in(@user)
    visit dashboard_path
    expect(page).to have_content("Pending")
    sign_out(@user)
    sign_in(@teacher)
    visit dashboard_path
    expect(page).to have_content(@user.full_name)
    click_button('Wait List')
    expect(page).to_not have_content(@user.full_name)
    sign_out(@teacher)
    sign_in(@user)
    visit dashboard_path
    expect(page).to have_content('Wait List')
  end

  xit('allows teacher to add non-student to studio') do
  end
end
