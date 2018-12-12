class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"

  validates_presence_of :start_time, :end_time, :location, :kind

  before_validation :proper_start_time, :proper_end_time, :student_check, :available_time, :kind_check

  before_save :make_price

  default_scope { order(:start_time) }

  def address
    if self.location == 'teacher'
      return self.teacher.address
    elsif self.location == 'student'
      return self.student.address
    else
      return 'other'
    end
  end

  def duration_in_hours
    return (((self.end_time - self.start_time)/60)/60)
  end

  def self.add_new_week_of_lessons
    lessons = Lesson.where(repeat: true)
    lessons.each do |lesson|
      lesson.update_attribute(:repeat, false)
      new_lesson = Lesson.new(start_time: lesson.start_time + 1.week, end_time: lesson.end_time + 1.week, location: lesson.location, repeat: true, kind: lesson.kind)
      new_lesson.student = lesson.student
      new_lesson.teacher = lesson.teacher
      new_lesson.save!
    end
  end

  def self.week(start_time)
    end_time = start_time + 1.week
    lessons = Lesson.where("start_time >= ? AND end_time < ?", start_time, end_time)
  end

  def self.initial_of_repeating
    repeating_lessons = Lesson.where(repeat: true, confirmed: false)
    query_params = []
    repeating_lessons.each do |l| 
      i = 3
      initial_lesson = nil
      until !initial_lesson.nil?
        initial_lesson = Lesson.where(start_time: l.start_time - i.weeks, confirmed: false).first
        i -= 1
      end
      query_params << initial_lesson.start_time
    end
    Lesson.where(start_time: query_params)
  end

  def recurring?
    future_weeks = []
    6.times do |n|
      future_weeks << self.start_time + (1 + n).weeks
    end
    other_lessons = Lesson.where(student_id: self.student.id, repeat: true, start_time: future_weeks)
    !other_lessons.empty?
  end

  def transfer_credit
    student = self.student
    unpaid_lessons = student.learning_lessons.where(paid: false)
    credit = self.price
    unpaid_lessons.each do |ul|
      if credit - ul.price  >= 0
        credit -= ul.price
        ul.update_attribute(:paid, true)
      end
    end
    student.update_attribute(:credit, student.credit + credit)
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

  def make_price
    duration_in_hours = (self.end_time - self.start_time)/60.0/60.0
    self.price = duration_in_hours * self.student.rate_per_hour
    self.price = (self.price * 100).round / 100.0
  end

  def kind_check
    self.errors.add(:kind, "kind must be voice, piano, or voice/piano") unless ["voice", "piano", "voice/piano"].include?(self.kind)
  end
end
