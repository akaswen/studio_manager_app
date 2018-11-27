require 'rails_helper'

RSpec.feature "AddingPayments", type: :feature do
  before(:each) do
    @teacher = create(:teacher)
    @student = create(:student)
    sign_in(@teacher)
  end

  it("allows a teacher to create a payment") do
    visit dashboard_path
    within("#teacher-payments") do
      select(@student.full_name, from: "Student")
      fill_in("$", with: "145")
      expect{ click_button('Add Payment') }.to change{ Payment.count }.by(1)
    end
    expect{ @student.reload }.to change{ @student.credit }.by(145.0)
  end
end
