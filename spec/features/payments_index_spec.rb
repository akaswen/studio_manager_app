require 'rails_helper'

RSpec.feature "PaymentsIndices", type: :feature do
  describe('get index with params') do
    before(:each) do
      @teacher = create(:teacher)
      @payment = create(:payment)
      @student = @payment.user
      @payment2 = @student.payments.create(amount: 45, created_at: Time.now - 1.year)
      @payment3 = @student.payments.create(amount: 45, created_at: Time.now - 2.years)
      @payment4 = @student.payments.create(amount: 45, created_at: Time.now - 2.years)
      sign_in(@teacher)
      visit payments_path
     end
    
    it('it gets all lessons without params') do
      expect(page).to have_link(Time.now.strftime('%Y'))
      expect(page).to have_link((Time.now - 1.year).strftime('%Y'))
      expect(page).to have_link((Time.now - 2.year).strftime('%Y'))
      Payment.all.each do |payment|
        expect(page).to have_content(payment.user.full_name)
        expect(page).to have_content(payment.amount)
        expect(page).to have_content(payment.created_at.strftime('%b/%d/%Y'))
      end
   end

    it('it gets only lessons within the year if given in params') do
      click_link((Time.now - 1.year).strftime('%Y'))
      expect(page).to have_content(@payment2.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment3.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment4.created_at.strftime('%b/%d/%Y'))
      
      click_link((Time.now - 2.years).strftime('%Y'))
      expect(page).to_not have_content(@payment2.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment.created_at.strftime('%b/%d/%Y'))
      expect(page).to have_content(@payment3.created_at.strftime('%b/%d/%Y'))
      expect(page).to have_content(@payment4.created_at.strftime('%b/%d/%Y'))

      click_link(Time.now.strftime('%Y'))
      expect(page).to_not have_content(@payment2.created_at.strftime('%b/%d/%Y'))
      expect(page).to have_content(@payment.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment3.created_at.strftime('%b/%d/%Y'))
      expect(page).to_not have_content(@payment4.created_at.strftime('%b/%d/%Y'))
    end

    describe('deleting payments') do
      it('deletes a payment') do
        expect{
          click_link(href: payment_path(@payment))
        }.to change{ Payment.count }.by(-1)
        expect(page).to have_content("Payment History")
        expect(page).to_not have_link(href: payment_path(@payment))
      end
    end
  end
end
