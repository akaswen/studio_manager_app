require 'rails_helper'

RSpec.describe Payment, type: :model do
  before(:each) do
    @payment = build(:payment)
    @student = @payment.user
    @teacher = create(:teacher)
    @user = create(:user)
  end

  describe('validations') do
    it('is valid') do
      expect(@payment).to be_valid
    end

    it('has a user') do
      expect(@payment.user).to eq(@student)
    end

    it('cannot have a non-student user') do
      @payment.user = @teacher
      expect(@payment).to_not be_valid
      @payment.user = @user
      expect(@payment).to_not be_valid
    end

    it('has an amount') do
      @payment.amount = ''
      expect(@payment).to_not be_valid
    end

    it('cannot be less than 0 or 0') do
      @payment.amount = -15.00
      expect(@payment).to_not be_valid
      @payment.amount = 0
      expect(@payment).to_not be_valid
    end
  end

  it('rounds amount to nearest cent') do
    @payment.amount = 15.055
    @payment.save
    @payment.reload
    expect(@payment.amount).to eq(15.06)
  end


end
