require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  before(:each) do
    @teacher = create(:teacher)
    @student = create(:student)
    @user = create(:user)
    @user.confirm
  end

  describe("GET #new") do
    subject { get :new }

    it('renders a new template for a teacher') do
      sign_in(@teacher)
      subject
      expect(response).to render_template('new')
    end

    it('renders a new template for a student') do
      sign_in(@student)
      subject
      expect(response).to render_template('new')
    end

    it('redirects non-user') do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it('redirects a non-student non-teacher user') do
      sign_in(@user)
      subject
      expect(response).to redirect_to(root_path)
    end
  end

  describe("POST #create") do
  end
end
