require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  before(:each) do
    @lesson = create(:lesson)
    @teacher = @lesson.teacher
    @student = @lesson.student
    @user = create(:user)
    @user.confirm
  end

  describe('POST #create') do
    subject { post :create, params: { payment: { amount: 100.0, user_id: @student.id } } }

    it("allows a teacher to create a payment") do
      sign_in(@teacher) 
      expect{ subject }.to change{ Payment.count }.by(1)
    end

    it("changes lessons from unpaid to paid based on amount submitted") do
      sign_in(@teacher) 
      subject
      expect{ @lesson.reload }.to change{ @lesson.paid }.from(false).to(true)   
    end

    it("whatever is left over adds onto credit for user") do
      sign_in(@teacher) 
      subject
      expect{ @student.reload }.to change{ @student.credit }.from(0.0).to(55.0)
   end

    it("doesn't allow a student to create a payment") do
      sign_in(@student)
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(root_path)
    end

    it("doesn't allow a non-student to create a payment") do
      sign_in(@user)
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(root_path)
   end

    it("doesn't allow a non-user to create a payment") do
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(new_user_session_path)
   end

    it("redirects to root path with flash on successful submission") do
      sign_in(@teacher)
      subject
      expect(flash).to_not be_empty
    end

    it("redirects with flash on failed submission") do
      sign_in(@teacher)
      post :create, params: { payment: { user_id: @student.id } }
      expect(response).to redirect_to dashboard_path
      expect(flash).to_not be_empty
    end
  end
end
