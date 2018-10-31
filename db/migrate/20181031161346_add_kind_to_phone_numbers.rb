class AddKindToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :kind, :string
  end
end
