class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"

  validates_presence_of :start_time, :end_time, :location

  before_validation :proper_start_time, :proper_end_time

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

  private

  def proper_start_time
    self.errors.add(:start_time, message: "start time must be later than now") if self.start_time && self.start_time < Time.now
  end

  def proper_end_time
    self.errors.add(:end_time, message: "end time must be later than start time") if self.end_time  && self.start_time && self.end_time <= self.start_time
  end
end
