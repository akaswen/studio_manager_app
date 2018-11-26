class AddPaidToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :paid, :boolean, default: false
  end
end
