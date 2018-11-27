class AddCreditToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :credit, :float, default: 0.0
  end
end
