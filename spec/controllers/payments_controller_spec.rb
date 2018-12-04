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

  describe('GET #index') do
    before(:each) do
      @payment = Payment.new(user_id: @student.id, amount: 45.0)
      @payment.save
    end

    subject { get :index }

    it('gets all payments for the teacher') do
      sign_in(@teacher)
      subject
      expect(response).to render_template(:index)
    end

    it('redirects a student') do
      sign_in(@student)
      subject
      expect(response).to redirect_to(root_path)
    end

    it('redirects a non-student') do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
   end

    it('redirects a non-user') do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe('DELETE #destroy') do
    before(:each) do
      sign_in(@teacher)
      post :create, 
        params: { 
          payment: { 
            amount: 45.0, user_id: @student.id 
          } 
        }
      sign_out(@teacher)
      @payment = Payment.first
      @lesson.reload
    end

    subject { delete :destroy, params: { id: @payment.id } }

    it('lets a teacher delete a payment') do
      sign_in(@teacher)
      expect{ subject }.to change{ Payment.count }.by(-1)
      expect(response).to redirect_to(payments_path)
    end

    it("doesn't let a student delete a payment") do
      sign_in(@student)
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(root_path)
   end

    it("doesn't let a non-student delete a payment") do
      sign_in(@user)
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(root_path)
   end

    it("doesn't let a non-user delete a payemnt") do
      expect{ subject }.to change{ Payment.count }.by(0)
      expect(response).to redirect_to(new_user_session_path)
    end

    it("takes money away from credit when a payment is deleted") do
      @student.update_attribute(:credit, 45.0)
      sign_in(@teacher)
      subject
      expect{ @student.reload }.to change{ @student.credit }.from(45.0).to(0.0)
    end

    it("takes money away from paid lessons and marks them as unpaid") do
      sign_in(@teacher)
      subject
      expect{ @lesson.reload }.to change{ @lesson.paid }.from(true).to(false)
      @student.reload
      expect(@student.credit).to eq(0.0)
    end

    it("doesn't take away from paid lessons if they have passed and instead leaves negative credit") do
      @lesson.update_attribute(:start_time, @lesson.start_time - 1.week)
      @lesson.update_attribute(:end_time, @lesson.end_time - 1.week)
      sign_in(@teacher)
      subject
      @lesson.reload
      @student.reload
      expect(@lesson.paid).to eq(true)
      expect(@student.credit).to eq(-45.0)
    end

    it("does a combination of taking from credit and lessons but leaves unbalanced in credit") do
      @payment.update_attribute(:amount, 50.0)
      @student.update_attribute(:credit, 30.0)
      sign_in(@teacher)
      subject
      @lesson.reload
      @student.reload
      expect(@lesson.paid).to eq(false)
      expect(@student.credit).to eq(25.0)
    end

    xit("if the payment is made with paypal, it cannot be destroyed") do
    end
  end
end
