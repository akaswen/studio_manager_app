class AddUserIdToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_reference :phone_numbers, :user, foreign_key: true
  end
end
