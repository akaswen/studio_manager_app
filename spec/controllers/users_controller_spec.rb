require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user = create(:user)
    @user.confirm
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
      @user.update_attribute(:student, true)
      sign_in(@user)
      get :dashboard
      expect(response).to render_template(partial: '_student')
      expect(response).to_not render_template(partial: '_non_student')
      expect(response).to_not render_template(partial: '_teacher')
    end

    it "renders a view for teacher" do
      @user.update_attribute(:teacher, true)
      sign_in(@user)
      get :dashboard
      expect(response).to render_template(partial: '_teacher')
      expect(response).to_not render_template(partial: '_non_student')
      expect(response).to_not render_template(partial: '_student')
    end
  end

  describe "PATCH #wait_list" do
    before(:each) do
      @teacher = create(:teacher)
      @student = create(:student)
    end

    subject { 
      patch :wait_list, body: { id: @user.id }.to_json
      @user.reload
    }

    it "doesn't allow a non-user to change a student's status" do
      expect{ subject }.to_not change{ @user.status }
      expect(response.status).to be(302)
    end
    
    it "allows a teacher to update a student's status" do
      sign_in(@teacher)
      expect{ subject }.to change{ @user.status }.from('Pending').to('Wait Listed')
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
    before(:each) do
      @teacher = create(:teacher)
      @student = create(:student)
    end

    subject { 
      patch :add_student, body: { id: @user.id }.to_json
      @user.reload
    }

    it "doesn't allow a non-user to add a student to studio" do
      expect{ subject }.to_not change{ @user.student }
      expect(response.status).to be(302)
    end

    it "allows a teacher to add a new student" do
      sign_in(@teacher)
      expect{ subject }.to change{ @user.student }.from(false).to(true)
      @user.reload
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
  end
end
