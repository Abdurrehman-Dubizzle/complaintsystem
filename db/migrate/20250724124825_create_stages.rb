class CreateStages < ActiveRecord::Migration[8.0]
  def change
    create_table :stages do |t|
      t.references :stage_template, null: false, foreign_key: true
      t.string :title
      t.integer :order
      t.text :description

      t.timestamps
    end
  end
end
