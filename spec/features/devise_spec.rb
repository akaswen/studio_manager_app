require 'rails_helper'

RSpec.feature "Devises", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end

  describe('devise methods') do

    xit('user should be confirmable') do
      visit new_user_registration_path
      within('form') do
        fill_in 'Email', 'aaron1@example.com'
        fill_in 'First Name', 'Aaron'
        fill_in 'last Name', 'Kaswen'
        #fill in rest of form here
      end
    end

    xit('user password should be resetable') do
    end

    xit('user should be rememberable') do
    end

    xit('user account should be lockable') do
    end
  end
end
