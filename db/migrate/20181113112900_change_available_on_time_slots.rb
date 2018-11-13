class ChangeAvailableOnTimeSlots < ActiveRecord::Migration[5.2]
  def change
    change_column :time_slots, :available, :boolean, default: true
  end
end
