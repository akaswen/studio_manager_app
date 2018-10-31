require 'rails_helper'

RSpec.feature "Links", type: :feature, focus: true do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end


  describe "links not logged in" do
    xit "has correct links for home page" do
      visit home_path
      expect(page).to have_link("Home", href: root_path)
      expect(page).to have_link("About", href: about_path)
      expect(page).to have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign out", href: destroy_user_session_path)
    end 

    xit "has correct links for about page" do
      visit about_path
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('About', href: about_path)
      expect(page).to have_link("Sign in", href: new_user_session_path)
      expect(page).to_not have_link("Sign out", href: destroy_user_session_path)

    end
  end

  describe "links logged in" do
    it('should allow a user to sign in') do
      visit new_user_session_path
        within("#new_user") do
          fill_in 'Email', with: 'aaron@example.com'
          fill_in 'Password', with: 'Password1'
          click_button('Log in')
        end
      expect(page).to redirect_to(root_url)
    end
  end
end
