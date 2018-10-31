require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  before(:each) do
    @user = build(:user)
    @number = @user.phone_numbers.first
  end

  it('should be valid') do
    expect(@number).to be_valid
  end

  it('should have a number') do
    @number.number = ''
    expect(@number).to_not be_valid
  end

  it('should have 10 numbers') do
    @number.number = "9" * 9
    expect(@number).to_not be_valid
    @number.number = "9" * 11
    expect(@number).to_not be_valid
  end

  it('should work with different types of entries') do
    @number.number = "(555)5555555"
    expect(@number).to be_valid
    @number.number = "555-555-5555"
    expect(@number).to be_valid
    @number.number = "(555) 555 - 5555"
    expect(@number).to be_valid
  end

  it('should save just the numbers') do
    @number.number = "(555) 555 - 5555"
    @user.save
    @user.reload
    expect(@user.phone_numbers.first.number).to eq("5555555555")
  end

  it('should display the number in a readable way') do
    @number.number = "0123456789"
    @user.save
    @user.reload
    expect(@user.phone_numbers.first.pretty_number).to eq("(012) 345 - 6789")
  end

  it('should have a kind') do
    @number.kind = ""
    expect(@number).to_not be_valid
  end

  it('validates kind') do
    @number.kind = "banana"
    expect(@number).to_not be_valid
  end

  it('downcases kind') do
    @number.kind = "HoME"
    expect(@number).to be_valid
  end
end
