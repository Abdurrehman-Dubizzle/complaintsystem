class CreateUserComplaints < ActiveRecord::Migration[8.0]
  def change
    create_table :user_complaints do |t|
      t.references :user, null: false, foreign_key: true
      t.references :complaint, null: false, foreign_key: true

      t.timestamps
    end
  end
end
