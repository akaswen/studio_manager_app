require 'rails_helper'

RSpec.feature "Devises", type: :feature, focus: true do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe('devise methods') do

    describe ('confirmable') do
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

      it('user should be confirmable') do
        expect { click_button('Sign up') }.to change{ ActionMailer::Base.deliveries.count }.by(1)
        @user = User.find_by(email: 'aaron1@example.com')
        expect(@user).to_not be_confirmed
        email = ActionMailer::Base.deliveries.last
        confirmation_path = email.body.match(/(?:"https?\:\/\/.*?)(\/.*?)(?:")/)[1]
        visit confirmation_path
        @user.reload
        expect(@user).to be_confirmed
        expect(page).to have_link('Sign out')
      end

      xit('should redirect and style properly for failed attempts') do
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
