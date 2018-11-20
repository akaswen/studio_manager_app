class TimeSlotsController < ApplicationController
  include TimeSlotsHelper
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def update
    time_slots = []
    JSON.parse(params["ids"]).each do |id|
      time_slot = TimeSlot.find(id)
      6.times do |n|
        time = next_date_on_day_with_time(time_slot.day, time_slot.time) + n.weeks
        lesson = Lesson.where("start_time <= ? AND end_time > ?", time, time)
        raise unless lesson.empty?
      end
      time_slots << time_slot
    end
    time_slots.each do |ts|
      if params["available"] == "true"
        ts.update_attribute(:available, true)
      else 
        ts.update_attribute(:available, false)
      end
    end
  end
end
