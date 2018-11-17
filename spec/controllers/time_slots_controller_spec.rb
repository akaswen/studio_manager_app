require 'rails_helper'

RSpec.describe TimeSlotsController, type: :controller do
  before(:each) do
    @user = create(:user)
    @user.confirm
    @student = create(:student)
    @schedule = create(:schedule)
    @teacher = @schedule.user
    @time_slot = @schedule.time_slots.first
  end
  
  it('updates a single time slot via json request') do
    sign_in(@teacher)
    post :update, params: {ids: [@time_slot.id].to_json, available: false }
    @time_slot.reload
    expect(@time_slot.available).to eq(false)
    post :update, params: {ids: [@time_slot.id].to_json, available: true }
    @time_slot.reload
    expect(@time_slot.available).to eq(true)
  end

  it("doesn't let a non-user update time slots") do
    post :update, params: {ids: [@time_slot.id].to_json, available: false }
    @time_slot.reload
    expect(@time_slot.available).to eq(true)
  end

  it("doesn't let a non-student update time slots") do
    sign_in(@user)
    post :update, params: {ids: [@time_slot.id].to_json, available: false }
    @time_slot.reload
    expect(@time_slot.available).to eq(true)

  end

  it("doesn't let a student update time slots") do
    sign_in(@student)
    post :update, params: {ids: [@time_slot.id].to_json, available: false }
    @time_slot.reload
    expect(@time_slot.available).to eq(true)

  end

end
