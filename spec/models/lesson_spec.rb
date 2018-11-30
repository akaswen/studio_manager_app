require 'rails_helper'

RSpec.describe Lesson, type: :model do
  before(:each) do
    @lesson = build(:lesson)
    @student = @lesson.student
    @teacher = @lesson.teacher
    @user = create(:user)
    @user.confirm
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

    it('validates that the student is a student') do
      @lesson.student = @user
      expect(@lesson).to_not be_valid
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

    describe('time slot validations') do
      before(:each) do
        @schedule = @teacher.create_schedule
      end

      it("doesn't allow a student to create a lesson when there is another lesson in the same time slot") do
        @lesson.save
        @new_lesson = Lesson.new(attributes_for(:lesson))
        @new_lesson.teacher = @teacher
        @new_lesson.student = @student
        3.times do |n|
          @new_lesson.start_time = @lesson.start_time - (15 + n * 15).minutes
          @new_lesson.end_time = @lesson.end_time - (15 + n * 15).minutes
          expect(@new_lesson).to_not be_valid
          @new_lesson.start_time = @lesson.start_time + (15 + n * 15).minutes
          @new_lesson.end_time = @lesson.end_time + (15 + n * 15).minutes
        end
        @new_lesson.start_time = @lesson.start_time - 1.hour
        @new_lesson.end_time = @lesson.end_time - 1.hour
        expect(@new_lesson).to be_valid
        @new_lesson.start_time = @lesson.start_time + 1.hour
        @new_lesson.end_time = @lesson.end_time + 1.hour
        expect(@new_lesson).to be_valid
      end

      it("doesn't allow a student to create a lesson when the time slot is unavailable") do
        time_slots = TimeSlot.where("time >= ? AND time < ? AND day = ?", @lesson.start_time.getlocal.strftime("%H:%M"), @lesson.end_time.getlocal.strftime("%H:%M"), @lesson.start_time.wday)
        time_slots.each do |ts|
          ts.update_attribute(:available, false)
          expect(@lesson).to_not be_valid
          ts.update_attribute(:available, true)
          expect(@lesson).to be_valid
        end
      end
    end

    it('has a kind') do
      @lesson.kind = ''
      expect(@lesson).to_not be_valid
    end

    it('only accepts the proper kind') do
      @lesson.kind = 'banana'
      expect(@lesson).to_not be_valid
    end
  end

  it('has default value of false for confirmed') do
    expect(@lesson.confirmed).to eq(false)
  end

  describe('price') do
    it('has a price after save') do
      @lesson.save
      expect(@lesson.price).to eq(45)
    end

    it('returns different prices for different rates') do
      @student.update_attribute(:rate_per_hour, 60)
      @lesson.save
      expect(@lesson.price).to eq(60)
    end

    it('returns different prices for different lengths of lessons') do
      @lesson.end_time = Time.now.utc.beginning_of_day + 5.days + 10.hours + 30.minutes
      @lesson.save
      expect(@lesson.price).to eq(22.5)
    end

    it("doesn't change price for a lesson already created after changing a student's rate") do
      @lesson.save
      expect(@lesson.price).to eq(45)
      @student.update_attribute(:rate_per_hour, 100)
      expect(@lesson.price).to eq(45)
    end

    it("rounds to the nearest cent") do
      @student.update_attribute(:rate_per_hour, 100)
      @lesson.end_time = Time.now.utc.beginning_of_day + 5.days + 10.hours + 20.minutes
      @lesson.save
      expect(@lesson.price).to eq(33.33)
    end
  end

  describe('self.add_new_week_of_lessons') do
    it('can duplicate a lesson that is set to repeat') do
      @lesson.repeat = true
      @lesson.save
      expect{ Lesson.add_new_week_of_lessons }.to change{ Lesson.count }.by(1)
      @lesson.reload
      expect(@lesson.repeat).to eq(false)
      new_lesson = Lesson.last
      expect(new_lesson.repeat).to be(true)
      expect(new_lesson.start_time).to eq(@lesson.start_time + 1.week)
      expect(new_lesson.end_time).to eq(@lesson.end_time + 1.week)
      expect(new_lesson.location).to eq(@lesson.location)
      expect(new_lesson.teacher).to eq(@lesson.teacher)
      expect(new_lesson.student).to eq(@lesson.student)
    end

    it('duplicates all lessons set to repeat') do
      @lesson.repeat = true
      lesson2 = Lesson.new(start_time: @lesson.start_time + 1.hour, end_time: @lesson.end_time + 1.hours, location: @lesson.location, repeat: true, kind: @lesson.kind)
      lesson2.student = @lesson.student
      lesson2.teacher = @lesson.teacher
      lesson3 = Lesson.new(start_time: @lesson.start_time + 2.hours, end_time: @lesson.end_time + 2.hours, location: @lesson.location, repeat: true, kind: @lesson.kind)
      lesson3.student = @lesson.student
      lesson3.teacher = @lesson.teacher

      lesson4 = Lesson.new(start_time: @lesson.start_time + 3.hour, end_time: @lesson.end_time + 3.hours, location: @lesson.location, repeat: true, kind: @lesson.kind)
      lesson4.student = @lesson.student
      lesson4.teacher = @lesson.teacher

      @lesson.save
      lesson2.save
      lesson3.save
      lesson4.save
      expect{ Lesson.add_new_week_of_lessons }.to change{ Lesson.count }.by(4)
    end
  end

  describe('initial of recurring') do
    before(:each) do
      @lesson.save
      make_recurring(@lesson, false)
    end

    it('returns the first lesson when a set of recurring lessons is made') do
      expect(Lesson.initial_of_repeating.first).to eq(@lesson)
    end

    it('returns the first lesson when a set of recurring lessons is made but the first lesson has been deleted') do
      @lesson2 = Lesson.new(attributes_for(:lesson2))
      @lesson2.student = @student
      @lesson2.teacher = @teacher
      @lesson2.save!
      make_recurring(@lesson2, false)

      @lesson3 = Lesson.new(attributes_for(:lesson3))
      @lesson3.student = @student
      @lesson3.teacher = @teacher
      @lesson3.save!
      make_recurring(@lesson3, false)

      @lesson4 = Lesson.new(attributes_for(:lesson4))
      @lesson4.student = @student
      @lesson4.teacher = @teacher
      @lesson4.save!
      make_recurring(@lesson4, false)

      expect(Lesson.initial_of_repeating).to include(@lesson, @lesson2, @lesson3, @lesson4)
     end

    it('works with multiple sets of recurring lessons') do
      @lesson.destroy
      2.times do
        lesson = Lesson.first
        expect(Lesson.initial_of_repeating.first).to eq(lesson)
        lesson.destroy
      end
    end
  end

  describe('recurring') do
    it('returns true for recurring lessons') do
      @lesson.save
      make_recurring(@lesson)
      expect(@lesson).to be_recurring
    end

    it('returns false for non-recurring lessons') do
      expect(@lesson).to_not be_recurring
    end
  end

  it('has an initial paid value of false') do
    expect(@lesson.paid).to eq(false)
  end
end
