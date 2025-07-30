class UserComplaint < ApplicationRecord
  belongs_to :user
  belongs_to :complaint

  # this helps in validating that only these three are used also

  VALID_ROLES = %w[complainer forwarded_to against]
  validates :role, presence: true, inclusion: { in: VALID_ROLES }

end
