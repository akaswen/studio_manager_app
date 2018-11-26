class AddTaughtToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :taught, :boolean, default: false
  end
end
