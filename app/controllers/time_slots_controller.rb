class TimeSlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_teacher

  def update
    JSON.parse(params["ids"]).each do |id|
      @time_slot = TimeSlot.find(id)
      if params["available"] == "true"
        @time_slot.update_attribute(:available, true)
      else 
        @time_slot.update_attribute(:available, false)
      end
    end
  end
end
