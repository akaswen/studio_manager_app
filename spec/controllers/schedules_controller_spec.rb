require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @student = create(:student)
    @teacher = create(:teacher)
  end

  describe "GET #edit" do
    it "allows a teacher access" do
      sign_in(@teacher)
      get :edit
      expect(response).to have_http_status(:success)
    end

    it "redirects a non-user" do
      get :edit
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects a non-student" do
      sign_in(@user)
      get :edit
      expect(response).to redirect_to(root_path)
    end

    it "redirects a student" do
      sign_in(@student)
      get :edit
      expect(response).to redirect_to(root_path)
    end
  end

end
