class CreateComplainMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :complain_messages do |t|
      t.references :complaint, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
