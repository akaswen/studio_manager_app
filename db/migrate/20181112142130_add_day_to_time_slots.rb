class AddDayToTimeSlots < ActiveRecord::Migration[5.2]
  def change
    add_column :time_slots, :day, :integer
  end
end
