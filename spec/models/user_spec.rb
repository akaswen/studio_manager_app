require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = build(:user)
    @address = @user.addresses.first
    @number = @user.phone_numbers.first
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
        @other_user = User.new(attributes_for(:user))
        @other_user.addresses << build(:address)
        @other_user.phone_numbers << build(:phone_number)
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
      before(:each) do
        @other_user = User.new(attributes_for :user)
      end
      describe('addresses') do
        it('should have at least one address') do
          @other_user.phone_numbers << build(:phone_number)
          expect(@other_user).to_not be_valid
          @other_user.addresses << build(:address)
          expect(@other_user).to be_valid
        end

        it('should delete addresses when it is destroyed') do
          expect{@user.save}.to change{Address.count}.by(1)
          @user.reload
          expect{@user.destroy}.to change{Address.count}.by(-1)
        end
      end

      describe('phone numbers') do
        it('should have at least one phone number') do
          @other_user.addresses << build(:address)
          expect(@other_user).to_not be_valid
          @other_user.phone_numbers << build(:phone_number)
          expect(@other_user).to be_valid
        end

        it('should delete phone numbers when it is deleted') do
          expect{@user.save}.to change{PhoneNumber.count}.by(1)
          @user.reload
          expect{@user.destroy}.to change{PhoneNumber.count}.by(-1)
        end
      end
    end
  end

end
