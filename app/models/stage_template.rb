class StageTemplate < ApplicationRecord
  has_many :stages, dependent: :destroy

  validates :category_type, presence: true, uniqueness: true
end
