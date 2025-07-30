class Stage < ApplicationRecord
  belongs_to :stage_template
  has_many :stage_questions, dependent: :destroy

  validates :title, presence: true
end
