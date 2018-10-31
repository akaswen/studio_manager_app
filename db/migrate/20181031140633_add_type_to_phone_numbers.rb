class AddTypeToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :type, :string
  end
end
