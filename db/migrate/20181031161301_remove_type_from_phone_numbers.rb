class RemoveTypeFromPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    remove_column :phone_numbers, :type
  end
end
