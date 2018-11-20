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

  it ("it doesn't allow making a slot unavailable if there is a lesson in that slot") do
    @lesson = Lesson.new(attributes_for(:lesson))
    @lesson.teacher = @teacher
    @lesson.student = @student
    @lesson.save!
    @time_slot = TimeSlot.where(day: @lesson.start_time.wday, time: @lesson.start_time.strftime("%H:%M"))
    expect{
      post :update, params: { ids: [@time_slot.id].to_json, available: false }
    }.to raise_error
  end

  it("it doesn't allow making unavailable a whole day of slots if there's a lesson within any slot") do
    @lesson = Lesson.new(attributes_for(:lesson))
    @lesson.teacher = @teacher
    @lesson.student = @student
    @lesson.save!
    @slots = TimeSlot.where(day: @lesson.start_time.wday)
    sign_in(@teacher)
    expect{
      post :update, params: { ids: (@slots.map { |s| s.id }).to_json, available: false }
    }.to raise_error
    @slots.each do |s|
      expect(s.available).to eq(true)
    end
  end
end
