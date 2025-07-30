class StageQuestion < ApplicationRecord
  belongs_to :stage

  # e.g., text, multiple_choice, tick_cross
  validates :question_type, inclusion: { in: %w[text multiple_choice tick_cross] }
end
