class AddAvatarToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :avatar, :string
  end
end
