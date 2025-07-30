class AddRoleToUserComplaints < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :role, :string
    remove_column :complaints, :complainer, :string
    remove_column :complaints, :forwarded_to, :string
    remove_column :complaints, :against_user, :string
  end
end
