require 'rails_helper'

RSpec.feature "Links", type: :feature do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end


  describe "links not logged in" do
    it "has correct links not logged in" do
      visit home_path
      expect(page).to have_link("Home", href: root_path)
      expect(page).to have_link("About", href: about_path)
      expect(page).to have_link("Sign in", href: new_user_session_path)
      expect(page).to have_link("Sign up", href: new_user_registration_path)
      expect(page).to_not have_link("Sign out", href: destroy_user_session_path)
      expect(page).to_not have_link("Dashboard", href: user_path(@user))
    end 
  end

  describe "links logged in" do
    it('has correct links logged in') do
      sign_in(@user)
      visit root_path
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to_not have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign up", href: new_user_registration_path)
      expect(page).to have_link("Sign out", href: destroy_user_session_path)
      expect(page).to have_link("Dashboard", href: user_path(@user))
    end
  end
end
