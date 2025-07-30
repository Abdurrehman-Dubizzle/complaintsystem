class StageResponse < ApplicationRecord
  belongs_to :complaint_stage
  belongs_to :stage_question
  belongs_to :user

  validates :answer_text, presence: true
end
