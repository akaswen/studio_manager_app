class AddStudentIdToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :student_id, :integer
  end
end
