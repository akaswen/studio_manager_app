require 'rails_helper'

RSpec.feature "Devises", type: :feature  do
  before(:each) do
    @user = create(:user)
    @user.confirm
  end

  describe('devise methods') do

    it('user password should be resetable') do
    end

    it('user should be rememberable') do
    end

    it('user should be confirmable') do
    end

    it('user account should be lockable') do
    end
  end
end
