class AddReviewerApprovalAndDecisionToComplaintStages < ActiveRecord::Migration[8.0]
  def change
    add_column :complaint_stages, :reviewer_id, :integer
    add_column :complaint_stages, :reviewer_approved, :boolean
    add_column :complaint_stages, :forwarded_decision, :text
  end
end
