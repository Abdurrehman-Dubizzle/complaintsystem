class User < ApplicationRecord
  has_ancestry

  belongs_to :report_to, class_name: 'User', optional: true
  has_many :reportees, class_name: 'User', foreign_key: :report_to_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_complaint, dependent: :destroy
  has_many :complaint, through: :user_complaint
  has_many :complain_messages, dependent: :destroy

  has_many :sent_complaints, -> { where(user_complaints: { role: "complainer" }) }, through: :user_complaint, source: :complaint
  has_many :received_complaints, -> { where(user_complaints: { role: "against" }) }, through: :user_complaint, source: :complaint
  has_many :forwarded_complaints, -> { where(user_complaints: { role: "forwarded_to" }) }, through: :user_complaint, source: :complaint

  before_create :assign_parent_from_report_to
  before_create :check_designation #cant create user with lower designation as manager

  def assign_parent_from_report_to
    self.parent = report_to if report_to.present?
  end

  def admin?
    designation == "admin"
  end


  DESIGNATION_RANK = {
    "admin" => 4,
    "Director" => 3,
    "Manager"  => 2,
    "Employee" => 1
  }

  def check_designation
    return if report_to.nil?

    manager = User.find_by(id: report_to)
    return if manager.nil?

    if DESIGNATION_RANK[self.designation] >= DESIGNATION_RANK[manager.designation]
      errors.add(:base, "You must report to someone with a higher designation")
      throw(:abort)
    end
  end
end
