class CreateStageTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :stage_templates do |t|
      t.string :category_type
      t.string :name

      t.timestamps
    end
  end
end
