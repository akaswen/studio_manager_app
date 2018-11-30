class AddKindToLessons < ActiveRecord::Migration[5.2]
  def change
    add_column :lessons, :kind, :string
  end
end
