class TimeSlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def update
    r = JSON.load(request.body)
    r["ids"].each do |id|
      @time_slot = TimeSlot.find(id)
      if r["available"]
        @time_slot.update_attribute(:available, true)
      else 
        @time_slot.update_attribute(:available, false)
      end
    end
  end
end
