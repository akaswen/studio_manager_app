require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(first_name: "Aaron", last_name: "Kaswen", email: "aaron@example.com", password: "Password1", password_confirmation: "Password1")
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
        @user.first_name = 'AaRoN'
        @user.last_name = 'KaSwEn'
        @user.save
        expect(@user.first_name).to eq('aaron')
        expect(@user.last_name).to eq('kaswen')
      end

      it('returns a full name') do
        expect(@user.full_name).to eq('Aaron Kaswen')
      end
    end

    describe('email') do
    end

    describe('password') do
    end

    describe('associated objects') do
      describe('addresses') do
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
