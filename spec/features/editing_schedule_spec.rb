require 'rails_helper'

RSpec.feature "EditingSchedules", type: :feature do
  before(:each) do
    @schedule = create(:schedule)
    @time_slot = @schedule.time_slots.first
    @teacher = @schedule.user
    @student = create(:student)
    ActionController::Base.allow_forgery_protection = true
  end

  after(:each) do
    ActionController::Base.allow_forgery_protection = false
  end

  it('allows a teacher to change availability of time slots', js: true) do
    @schedule.time_slots.sunday_slots.each do |s|
      expect(s.available).to eq(true)
    end
    sign_in(@teacher)
    click_link('Set Schedule')
    within('.sunday') do
      find('.btn-outline-danger').click
    end
    find('.fa-calendar-alt').click
    @schedule.time_slots.sunday_slots.each do |s|
      expect(s.available).to eq(false)
    end
    within('.sunday') do
      click_button('07:45 pm')
    end
    find('.fa-calendar-alt').click
    expect(@schedule.time_slots.sunday_slots.last.available).to eq(true)
  end
end
