class MakeComplaintTable < ActiveRecord::Migration[8.0]
  def change
    create_table :complaints do |t|
      t.string :complainer, null: false, default: nil
      t.string :against_user, null: false, default: nil
      t.string :forwarded_to, null: false, default: nil
      t.string :category_type, null: false, default: "ambigious"
      t.timestamps null: false
    end
  end
end
