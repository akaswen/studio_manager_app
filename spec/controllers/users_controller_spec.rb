require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @teacher = create(:teacher)
    @student = create(:student)
  end

  describe "GET #dashboard" do
    render_views

    it "redirects not logged in users" do
      get :dashboard
      expect(response).to redirect_to(home_path)
    end

    it "renders a view for non-students" do
      sign_in(@user)
      get :dashboard
      expect(response).to render_template(partial: '_non_student')
      expect(response).to_not render_template(partial: '_student')
      expect(response).to_not render_template(partial: '_teacher')
    end

    it "Renders a view for students" do
      sign_in(@student)
      get :dashboard
      expect(response).to render_template(partial: '_student')
      expect(response).to_not render_template(partial: '_non_student')
      expect(response).to_not render_template(partial: '_teacher')
    end

    it "renders a view for teacher" do
      sign_in(@teacher)
      get :dashboard
      expect(response).to render_template(partial: '_teacher')
      expect(response).to_not render_template(partial: '_non_student')
      expect(response).to_not render_template(partial: '_student')
    end

    it "doesn't include non-confirmed users in teacher's new students" do
      @other = create(:user, email: "aaron1@example.com")
      sign_in(@teacher)
      get :dashboard
      expect(assigns(:new_students)).to_not include(@other)
    end

    it "gets the first of repeating lessons and not the last" do
      @lesson = Lesson.new(attributes_for(:lesson))
      @lesson.student = @student
      @lesson.teacher = @teacher
      @lesson.save
      make_recurring(@lesson, false)
      sign_in(@teacher)
      get :dashboard
      expect(assigns(:weekly_lesson_requests)[0]).to eq(@lesson)
    end
  end

  describe "PATCH #wait_list" do
    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    subject { 
      patch :wait_list, params: { id: @user.id }
      @user.reload
    }

    it "doesn't allow a non-user to change a student's status" do
      expect{ subject }.to_not change{ @user.status }
      expect(response.status).to be(302)
    end
    
    it "allows a teacher to update a student's status" do
      sign_in(@teacher)
      expect{ subject }.to change{ @user.status }.from('Pending').to('Wait Listed').and change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    it "doesn't allow a non-student to update a student's status" do
      sign_in(@user)
      expect{ subject }.to_not change{ @user.status }
      expect(response.status).to be(302)
    end

    it "doesn't allow a student to update a student's status" do
      sign_in(@student)
      expect{ subject }.to_not change{ @user.status }
      expect(response.status).to be(302)
    end
  end

  describe "PATCH #add_student" do
    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    subject { 
      patch :add_student, params: { id: @user.id, rate: "45" }
      @user.reload
    }

    it "doesn't allow a non-user to add a student to studio" do
      expect{ subject }.to_not change{ @user.student }
      expect(response.status).to be(302)
    end

    it "allows a teacher to add a new student" do
      sign_in(@teacher)
      expect{ subject }.to change{ @user.student }.from(false).to(true).and change{ ActionMailer::Base.deliveries.count }.by(1)
      expect(@user.status).to be_nil
    end

    it "doesn't allow a non-student to add a student" do
      sign_in(@user)
      expect{ subject }.to_not change{ @user.student }
      expect(response.status).to be(302)
    end

    it "doesn't allow a student to add a student" do
      sign_in(@student)
      expect{ subject }.to_not change{ @user.student }
      expect(response.status).to be(302)
    end

    it("sets a student's rate") do
      sign_in(@teacher)
      subject
      expect(@user.rate_per_hour).to eq(45)
    end

    it("requires a student's rate to be set") do
      sign_in(@teacher)
      expect{
        patch :add_student, params: { id: @user.id }
      }.to raise_error("requires a rate per hour")
    end
  end

  describe "GET #index" do
    render_views

    it("redirects without a parameter") do
      sign_in(@teacher)
      get :index
      expect(response).to redirect_to(root_path)
    end

    it('redirects if parameter is neither studio or wait_list') do
      sign_in(@teacher)
      get :index, params: { student: 'miscellaneous', status: 'miscellaneous' }
      expect(response).to redirect_to(root_path)
    end

    it('allows teacher to see studio') do
      sign_in(@teacher)
      get :index, params: { student: true }
      expect(response.body).to include(@student.full_name)
    end

    it('allows teacher to see wait list') do
      @user.update_attributes(status: 'Wait Listed')
      sign_in(@teacher)
      get :index, params: { status: 'Wait Listed' }
      expect(response.body).to match(@user.full_name)
    end

    it("doesn't allow non-user to access studio/wait list") do
      get :index, params: { student: true }
      expect(response).to redirect_to(new_user_session_path)
      get :index, params: { status: 'Wait Listed' }
      expect(response).to redirect_to(new_user_session_path)
    end

    it("doesn't allow non-student to access studio/wait list") do
      sign_in(@user)
      get :index, params: { student: true }
      expect(response).to redirect_to(root_path)
      get :index, params: { status: 'Wait Listed' }
      expect(response).to redirect_to(root_path)
    end

    it("doesn't allow student to access studio/wait list") do
      sign_in(@student)
      get :index, params: { student: true }
      expect(response).to redirect_to(root_path)
      get :index, params: { status: 'Wait Listed' }
      expect(response).to redirect_to(root_path)
    end
  end

  describe('GET #show') do
    subject { get :show, params: { id: @user.id } }

    it("Doesn't allow a non-user to see a student's profile") do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it("Allows a teacher to see a student's profile") do
      sign_in(@teacher)
      subject
      expect(assigns(:user)).to eq(@user)
      expect(response).to render_template('show')
    end

    it("Doesn't allow a non-student to see a student's profile") do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
    end

    it("Doesn't allow a student to see a student's profile") do
      sign_in(@student)
      subject
      expect(response).to redirect_to(root_path)

    end

    it("redirects a show of teahcer's account") do
      sign_in(@teacher)
      get :show, params: { id: @teacher.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe('DELETE #delete') do
    after(:each) do
      ActionMailer::Base.deliveries.clear
    end

    subject { delete :destroy, params: { id: @user.id } }

    it("doesn't allow a non-user to deactivate a student") do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it("Allows a teacher to deactivate a student or non-student") do
      sign_in(@teacher)
      subject
      expect{ @user.reload }.to change { @user.active }.from(true).to(false)
    end

    it("sends a deactivation email") do
      sign_in(@teacher)
      expect{ subject }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end

    it("allows a student to deactivate their own account") do
      sign_in(@student)
      delete :destroy, params: { id: @student.id }
      expect(response).to redirect_to(home_path)
      expect{ @student.reload }.to change{ @student.active }.from(true).to(false)
    end

    it("allows a non-student to deactivate their own account") do
      sign_in(@user)
      subject
      expect(response).to redirect_to(home_path)
      expect{ @user.reload }.to change { @user.active }.from(true).to(false)
    end

    it("doesn't allow a non-teacher user to deactivate another user's account") do
      sign_in(@student)
      subject
      expect(response).to redirect_to(root_path)
    end
    
    it("Doesn't allow a non-active user to do any signed-in actions") do
      subject { 
        sign_in(@teacher)
        @teacher.update_attribute(:active, false)
      }

      subject
      get :index
      expect(response).to redirect_to(new_user_session_path)
      subject
      get :show, params: { id: @user.id }
      expect(response).to redirect_to(new_user_session_path)
      subject
      delete :destroy, params: { id: @user.id }
      expect(response).to redirect_to(new_user_session_path)
      subject
      get :dashboard
      expect(response).to redirect_to(home_path)
    end
  end
end
