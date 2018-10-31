class AddNumberToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :number, :string
  end
end
