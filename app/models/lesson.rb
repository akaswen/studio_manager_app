class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"

  validates_presence_of :start_time, :end_time, :location

  before_validation :proper_start_time, :proper_end_time, :student_check, :available_time

  def address
    if self.location == 'teacher'
      return self.teacher.addresses.first
    elsif self.location == 'student'
      return self.student.addresses.first
    else
      return 'other'
    end
  end

  def duration_in_hours
    return (((self.end_time - self.start_time)/60)/60)
  end

  def price
    rate = self.student.rate_per_hour
    time = self.duration_in_hours
    return (((time * rate) * 100).round) / 100.0
  end

  def self.add_new_week_of_lessons
    lessons = Lesson.where(repeat: true)
    lessons.each do |lesson|
      lesson.update_attribute(:repeat, false)
      new_lesson = Lesson.new(start_time: lesson.start_time + 1.week, end_time: lesson.end_time + 1.week, location: lesson.location, repeat: true)
      new_lesson.student = lesson.student
      new_lesson.teacher = lesson.teacher
      new_lesson.save!
    end
  end

  def self.week(start_time)
    end_time = start_time + 1.week
    lessons = Lesson.where("start_time >= ? AND end_time < ?", start_time, end_time).all
  end

  private

  def proper_start_time
    self.errors.add(:start_time, message: "start time must be later than now") if self.start_time && self.start_time < Time.now
  end

  def proper_end_time
    self.errors.add(:end_time, message: "end time must be later than start time") if self.end_time  && self.start_time && self.end_time <= self.start_time
  end

  def student_check
    self.errors.add(:student, message: "student must be added to studio") unless self.student.student
  end

  def available_time
    if self.start_time && self.end_time
      lesson = Lesson.where("start_time <= ? AND end_time > ? OR start_time < ? AND end_time >= ?", self.start_time, self.start_time, self.end_time, self.end_time)

      time_slots = TimeSlot.where("time >= ? AND time < ? AND day = ? AND available = ?", 
                                  self.start_time.getlocal.to_datetime.strftime("%H:%M"), 
                                  self.end_time.getlocal.to_datetime.strftime("%H:%M"), 
                              self.start_time.wday, 
                              false
                            )

        self.errors.add(:start_time, message: "This time slot is unavailable") unless lesson.empty? && time_slots.empty?
    end
  end
end
