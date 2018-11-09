class AddRatePerHourToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rate_per_hour, :integer
  end
end
