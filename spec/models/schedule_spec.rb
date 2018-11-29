require 'rails_helper'

RSpec.describe Schedule, type: :model do
  before(:each) do
    @schedule = build(:schedule)
    @teacher = @schedule.user
    @student = create(:student)
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

  it('only allows a teacher to have a schedule') do
    @schedule.user = @student
    expect(@schedule).to_not be_valid
  end
end
