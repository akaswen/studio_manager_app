require 'rails_helper'

RSpec.describe LessonsHelper, type: :helper do
  describe('wday_number') do
    it('returns a number for a weekday') do
      expect(wday_number('monday')).to eq(1)
      expect(wday_number('saturday')).to eq(6)
    end
  end

  describe('get_start_time') do
    before(:each) do
      @day = "monday"
      @time = "14:30"
    end

    it('returns a datetime object of the next monday at 10:30') do
      result = get_start_time(@day, @time)
      expect(result > Time.now).to be_truthy
      expect(result.to_datetime.hour).to be(14)
      expect(result.to_datetime.minute).to be(30)
      expect(result.to_datetime.wday).to be(1)
    end

    it('can get multiple future start times') do
      result1 = get_start_time(@day, @time)
      result2 = get_start_time(@day, @time, result1)
      result3 = get_start_time(@day, @time, result2)
      result4 = get_start_time(@day, @time, result3)
      expect(result1 < result2).to be(true)
      expect(result2 < result3).to be(true)
      expect(result3 < result4).to be(true)
    end
  end
end
