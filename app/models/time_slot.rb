class TimeSlot < ApplicationRecord
  validates_presence_of :day, :time, :available
  validates_format_of :time, with: /\A\d{2}:\d{2}\Z/

  after_validation :day_range

  belongs_to :schedule

  default_scope { order('time') }

  def self.sunday_slots
    where(day: 0)
  end

  def self.monday_slots
    where(day: 1)
  end

  def self.tuesday_slots
    where(day: 2)
  end

  def self.wednesday_slots
    where(day: 3)
  end

  def self.thursday_slots
    where(day: 4)
  end

  def self.friday_slots
    where(day: 5)
  end

  def self.saturday_slots
    where(day: 6)
  end

  private

  def day_range
    self.errors.add(:day, message: "Please choose an integer between 1 and 7") if self.day.to_i < 0 or self.day.to_i > 6
  end
end
