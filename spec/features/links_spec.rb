require 'rails_helper'

RSpec.feature "Links", type: :feature do
  describe 'links not logged in' do
    it 'has correct links for home page' do
      visit home_path
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('About', href: about_path)
    end 

    it 'has correct links for about page' do
      visit about_path
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('About', href: about_path)
    end
  end
end
