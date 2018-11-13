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
    post :update, body: {ids: [@time_slot.id], available: false }.to_json
    @time_slot.reload
    expect(@time_slot.available).to eq(false)
    post :update, body: {ids: [@time_slot.id], available: true }.to_json
    @time_slot.reload
    expect(@time_slot.available).to eq(true)
  end

  it("doesn't let a non-user update time slots") do
    post :update, body: {ids: [@time_slot.id], available: false }.to_json
    @time_slot.reload
    expect(@time_slot.available).to eq(true)
  end

  it("doesn't let a non-student update time slots") do
    sign_in(@user)
    post :update, body: {ids: [@time_slot.id], available: false }.to_json
    @time_slot.reload
    expect(@time_slot.available).to eq(true)

  end

  it("doesn't let a student update time slots") do
    sign_in(@student)
    post :update, body: {ids: [@time_slot.id], available: false }.to_json
    @time_slot.reload
    expect(@time_slot.available).to eq(true)

  end

end
