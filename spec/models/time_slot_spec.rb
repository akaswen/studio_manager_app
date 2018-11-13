require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
  before(:each) do
    @schedule = create(:schedule)
    @time_slot = @schedule.time_slots.first
  end

  it('is valid') do
    expect(@time_slot).to be_valid
  end

  it('has a day') do
    @time_slot.day = ''
    expect(@time_slot).to_not be_valid
  end

  it('has a day number that is between 0 and 6') do
    @time_slot.day = -1 
    expect(@time_slot).to_not be_valid
    @time_slot.day = 7
    expect(@time_slot).to_not be_valid
  end

  it('has a time') do
    @time_slot.time = ''
    expect(@time_slot).to_not be_valid
  end

  it('validates format of time') do
    @time_slot.time = 'banana'
    expect(@time_slot).to_not be_valid
    @time_slot.time = '900'
    expect(@time_slot).to_not be_valid
    @time_slot.time = '080:15'
    expect(@time_slot).to_not be_valid
    @time_slot.time = '08:15 am'
    expect(@time_slot).to_not be_valid
  end

  it('has an available boolean') do
    @time_slot.available = ''
    expect(@time_slot).to_not be_valid
  end

  it('has a schedule') do
    expect(@time_slot.schedule).to be_truthy
  end
end
