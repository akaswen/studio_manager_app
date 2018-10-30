require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = build(:user)
    address_attr = attributes_for(:address)
    @address = @user.addresses.build(address_attr)
  end

  it('should be valid') do
    expect(@user).to be_valid
  end

  describe('validations') do
    describe('names') do
      it('validates presence of first name') do
        @user.first_name = ''
        expect(@user).to_not be_valid
      end

      it('validates presence of last name') do
        @user.last_name = ''
        expect(@user).to_not be_valid
      end

      it('lower cases names') do
        expect(User.count).to eq(0)
        @user.first_name = 'AaRoN'
        @user.last_name = 'KaSwEn'
        @user.save
        expect(User.count).to eq(1)
        expect(@user.first_name).to eq('aaron')
        expect(@user.last_name).to eq('kaswen')
      end

      it('returns a full name') do
        expect(@user.full_name).to eq('Aaron Kaswen')
      end
    end

    describe('email') do
      it('should be present') do
        @user.email = ''
        expect(@user).to_not be_valid
      end

      it('should be formatted correctly') do
        @user.email = 'aaronexample.com'
        expect(@user).to_not be_valid
        @user.email = 'aaron@examplecom'
        expect(@user).to_not be_valid
     end

      it('should be downcased before save') do
        @user.email = 'AarOn@ExaMPLe.CoM'
        @user.save
        @user.reload
        expect(@user.email).to eq('aaron@example.com')
      end

      it('should be unique and not by case') do
        @other_user = User.new(first_name: 'other', last_name: 'user', email: 'aaron@example.com', password: 'Password1', password_confirmation: 'Password1')
        @user.save
        expect(@other_user).to_not be_valid
        @other_user.email = 'AarOn@example.com'
        expect(@other_user).to_not be_valid
        @other_user.email = 'aaron1@example.com'
        expect(@other_user).to be_valid
     end
    end

    describe('password') do
      it('should have a minimum length of 8') do
        @user.password = 'Passwo1'
        @user.password_confirmation = 'Passwo1'
        expect(@user).to_not be_valid
      end

      it('should have at least one number') do
        @user.password = 'Password'
        @user.password_confirmation = 'Password'
        expect(@user).to_not be_valid
      end

      it('should have at least one capital') do
        @user.password = 'password1'
        @user.password_confirmation = 'password1'
        expect(@user).to_not be_valid
      end
    end

    describe('associated objects') do
      describe('addresses') do
        xit('should have at least one address') do
        end
      end

      describe('phone numbers') do
      end
    end
  end

  describe('devise methods') do
    it('should be resetable') do
    end

    it('should be rememberable') do
    end

    it('should be confirmable') do
    end

    it('should be lockable') do
    end
  end
end
