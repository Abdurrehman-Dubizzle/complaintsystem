class ComplaintStage < ApplicationRecord
  belongs_to :complaint
  belongs_to :stage

  has_many :stage_responses, dependent: :destroy

  def completed?
    self.completed
  end
end
