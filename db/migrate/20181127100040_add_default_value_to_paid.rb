class AddDefaultValueToPaid < ActiveRecord::Migration[5.2]
  def up
    change_column :lessons, :paid, :boolean, default: false
  end

  def down
    change_column :lessons, :paid, :boolean, default: nil
  end
end
