class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :school_email
      t.string :major
      t.string :minor
      t.date :graduation_date

      t.timestamps
    end

    add_index :students, :school_email, unique: true
  end
end
