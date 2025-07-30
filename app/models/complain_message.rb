class ComplainMessage < ApplicationRecord
  belongs_to :complaint
  belongs_to :user

  validates :content, presence: true
end
