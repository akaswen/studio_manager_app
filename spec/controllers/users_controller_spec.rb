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
      expect(response).to redirect_to(new_user_session_path)
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
end
