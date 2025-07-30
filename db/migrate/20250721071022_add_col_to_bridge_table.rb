class AddColToBridgeTable < ActiveRecord::Migration[8.0]
  def change
    add_column :user_complaints, :role, :string
    add_column :users, :designation, :string

  end
end
