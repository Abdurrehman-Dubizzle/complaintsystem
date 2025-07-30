class CreateStageResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :stage_responses do |t|
      t.references :complaint_stage, null: false, foreign_key: true
      t.references :stage_question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :answer_text

      t.timestamps
    end
  end
end
