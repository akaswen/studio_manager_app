require 'rails_helper'

RSpec.feature "Sign up", type: :feature do
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe('creating a new user') do
    before(:each) do
    visit new_user_registration_path
      within('form') do
        fill_in 'Email', with: 'aaron1@example.com'
        fill_in 'First name', with: 'Aaron'
        fill_in 'Last name', with: 'Kaswen'
        fill_in 'Password', with: 'Password1'
        fill_in 'Password confirmation', with: 'Password1'
        fill_in 'Street address', with: '555 street street'
        fill_in 'City', with: 'las vegas'
        select('NV', from: 'State')
        fill_in 'Zip code', with: '55555'
        fill_in 'Phone number', with: '555 555 5555'
        select('Home', from: 'Kind')
      end
    end

    it('should save a new user') do 
      expect { click_button('Sign up') }.to change{ User.count }.by(1)
    end

    it('should save a new address') do
      expect { click_button('Sign up') }.to change{ Address.count }.by(1)
    end

    it('should save a new phone number') do
      expect { click_button('Sign up') }.to change{ PhoneNumber.count }.by(1)
    end
  end
end
