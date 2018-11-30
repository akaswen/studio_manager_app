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

  describe('self.years') do
    before(:each) do
      @payment.save
      @payment2 = @student.payments.create(amount: 45)
    end

    it('it returns a year if there is a payment made in that year') do
      expect(Payment.years).to eq([Time.now.strftime('%Y')])
    end

    it('it returns multiple years if payments exist in multiple years') do
      @payment2.update_attribute(:created_at, Time.now - 1.year)
      expect(Payment.years).to eq([Time.now.strftime('%Y'), (Time.now - 1.year).strftime('%Y')])
    end

    it('it works for more than two years') do
      2.times { @student.payments.create!(amount: 45) }
      4.times do |n|
        Payment.all[n].update_attribute(:created_at, Time.now - n.years)
      end
      expect(Payment.years).to eq([
        Time.now.strftime('%Y'),
        (Time.now - 1.year).strftime('%Y'),
        (Time.now - 2.years).strftime('%Y'),
        (Time.now - 3.years).strftime('%Y')
      ])
    end
  end
end
