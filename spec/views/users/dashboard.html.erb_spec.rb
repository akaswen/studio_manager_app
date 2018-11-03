require 'rails_helper'

RSpec.describe "users/dashboard.html.erb", type: :view do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end

  it('says hello') do
    render

    expect(rendered).to match @user.full_name
  end

  describe('non-student dashboard') do
    it('shows pending for initial students') do
      render

      expect(rendered).to match /pending/i
    end

    it('shows wait listed otherwise') do
      @user.update_attribute(:status, 'Wait-Listed')
      render

      expect(rendered).to match 'Wait-Listed'
    end
  end
end
