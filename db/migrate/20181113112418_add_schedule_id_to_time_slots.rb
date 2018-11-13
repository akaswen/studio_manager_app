class AddScheduleIdToTimeSlots < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_slots, :schedule, foreign_key: true
  end
end
