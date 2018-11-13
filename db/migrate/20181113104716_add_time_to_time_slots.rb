class AddTimeToTimeSlots < ActiveRecord::Migration[5.2]
  def change
    add_column :time_slots, :time, :string
  end
end
