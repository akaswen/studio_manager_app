require 'rails_helper'

RSpec.describe Lesson, type: :model do
  before(:each) do
    @lesson = build(:lesson)
    @student = @lesson.student
    @teacher = @lesson.teacher
  end

  describe('validations') do
    it('is valid') do
      expect(@lesson).to be_valid
    end

    it('has a start time') do
      @lesson.start_time = ''
      expect(@lesson).to_not be_valid
    end

    it('has a start time later than now') do
      @lesson.start_time = Time.now - 1.hour
      expect(@lesson).to_not be_valid
      expect(@lesson.errors.full_messages[0]).to match("start time must be later than now")
    end

    it('has an end time') do
      @lesson.end_time = ''
      expect(@lesson).to_not be_valid
    end

    it('has an end time later than start time') do
      @lesson.end_time = Time.now + 4.days
      expect(@lesson).to_not be_valid
      expect(@lesson.errors.full_messages[0]).to match("end time must be later than start time")
    end

    it('has one student') do
      expect(@lesson.student).to eq(@student)
    end

    it('has one teacher') do
      expect(@lesson.teacher).to eq(@teacher)
    end

    it('has a location kind') do
      @lesson.location = ''
      expect(@lesson).to_not be_valid
    end

    it('returns an address for location based on kind') do
      expect(@lesson.address).to match(@teacher.addresses.first)
      @lesson.location = 'student';
      expect(@lesson.address).to match(@student.addresses.first)
    end

    describe('price') do
      it('returns a price') do
        expect(@lesson.price).to eq(45)
      end

      it('returns different prices for different rates') do
        @student.update_attribute(:rate_per_hour, 60)
        expect(@lesson.price).to eq(60)
      end

      it('returns different prices for different lengths of lessons') do
      end
    end
  end
end
