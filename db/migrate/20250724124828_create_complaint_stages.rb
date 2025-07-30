class CreateComplaintStages < ActiveRecord::Migration[8.0]
  def change
    create_table :complaint_stages do |t|
      t.references :complaint, null: false, foreign_key: true
      t.references :stage, null: false, foreign_key: true
      t.boolean :completed
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
