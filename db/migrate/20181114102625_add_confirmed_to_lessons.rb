class AddConfirmedToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :confirmed, :boolean, default: false
  end
end
