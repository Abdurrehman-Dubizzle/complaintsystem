class CreateStageQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :stage_questions do |t|
      t.references :stage, null: false, foreign_key: true
      t.string :question_text
      t.string :question_type

      t.timestamps
    end
  end
end
