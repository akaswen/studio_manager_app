class AddStreetAddressToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :street_address, :string
  end
end
