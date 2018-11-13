require 'rails_helper'

RSpec.describe Schedule, type: :model do
  before(:each) do
    @schedule = build(:schedule)
    @teacher = @schedule.user
  end

  it('is valid') do
    expect(@schedule).to be_valid
  end

  it('gives a teacher one schedule') do
    expect(@teacher.schedule).to eq(@schedule)
  end

  it('has many time slots') do
    @schedule.save
    expect(@schedule.time_slots.length).to eq(336)
  end
end
