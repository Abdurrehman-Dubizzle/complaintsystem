class Complaint < ApplicationRecord
  has_many :user_complaints, dependent: :destroy # used this so the delete works for user and complaints
  has_many :users, through: :user_complaints
  has_many :complain_messages, dependent: :destroy
  has_many :complaint_stages, dependent: :destroy

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  #mapping
  settings do
    mappings dynamic: false do
      indexes :category_type, type: :text
    end
  end

  before_create :set_status
  before_create :validate_roles

  def validate_roles
    roles = user_complaints.map(&:role)

    complainer_count = roles.count { |r| r == "complainer" }
    forwarded_count  = roles.count { |r| r == "forwarded_to" }
    against_count    = roles.count { |r| r == "against" }

    errors.add(:base, "Exactly one complainer is required") unless complainer_count == 1
    errors.add(:base, "Exactly one forwarded_to is required") unless forwarded_count == 1
    errors.add(:base, "At least one against user is required") if against_count < 1

    throw(:abort) if errors.any?
  end

  def set_status
    self.status ||= 'open'
  end
end