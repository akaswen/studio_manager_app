class AddAttributesToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :start_time, :datetime
    add_column :lessons, :end_time, :datetime
    add_column :lessons, :location, :string
  end
end
