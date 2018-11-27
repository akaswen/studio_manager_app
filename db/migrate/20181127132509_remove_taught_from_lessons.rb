class RemoveTaughtFromLessons < ActiveRecord::Migration[5.2]
  def change
    remove_column :lessons, :taught
  end
end
