class AddReportToIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :report_to_id, :integer
  end
end
