class AddAvailableToTimeSlots < ActiveRecord::Migration[5.2]
  def change
    add_column :time_slots, :available, :boolean
  end
end
