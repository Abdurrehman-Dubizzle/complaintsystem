class Addcoloumstatustocomplaints < ActiveRecord::Migration[8.0]
  def change
    add_column :complaints, :status, :string
  end
end
