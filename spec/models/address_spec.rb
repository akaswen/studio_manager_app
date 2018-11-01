require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:each) do
    @user = build(:user)
    @address = @user.addresses.first
  end  

  it('should be valid') do
    expect(@address).to be_valid
  end

  describe('street address') do
    it('should be present') do
      @address.street_address = ''
      expect(@address).to_not be_valid
    end

    it('should start with a number') do
      @address.street_address = "hill 55 street"
      expect(@address).to_not be_valid
    end

    it('should have both a name and a type of street') do
      @address.street_address = "55 street"
      expect(@address).to_not be_valid
    end
  end

  it('should have a city') do
    @address.city = ''
    expect(@address).to_not be_valid
  end 

  describe('state') do
    it('should have a state') do
      @address.state = ''
      expect(@address).to_not be_valid
    end

    it('state should be two letters') do
      @address.state = 'NJS'
      expect(@address).to_not be_valid
      @address.state = 'n'
      expect(@address).to_not be_valid
    end

    it('state will be automatically capitalized') do
      @address.state = 'nj'
      @address.save
      @address.reload
      expect(@address.state).to eq('NJ')
    end
  end

  describe('zip code') do
    it('should be present') do
      @address.zip_code = ''
      expect(@address).to_not be_valid
    end

    it('should be only numbers') do
      @address.zip_code = "afeew"
      expect(@address).to_not be_valid
    end

    it('should be five digits') do
      @address.zip_code = '555555'
      expect(@address).to_not be_valid
      @address.zip_code = '5555'
      expect(@address).to_not be_valid
    end
  end
end
