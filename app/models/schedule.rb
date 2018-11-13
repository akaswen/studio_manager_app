class Schedule < ApplicationRecord
  belongs_to :user
  has_many :time_slots, dependent: :destroy

  before_save :add_time_slots

  private
    
    def add_time_slots
      7.times do |d|
        12.times do |h|
          4.times do |m|
            min = m == 0 ? "00" : "#{m * 15}"
            hour = (8 + h).to_s.length < 2 ? "0#{8 + h}" : "#{8 + h}"
            self.time_slots.build(day: d, time: "#{hour}:#{min}")
          end
        end
      end
    end
end
