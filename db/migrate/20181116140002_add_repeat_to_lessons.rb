class AddRepeatToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :repeat, :boolean, default: false
  end
end
