class ComplaintReminderJob < ApplicationJob
  queue_as :default

  def perform
    complaints = Complaint.joins(:user_complaints)
                          .where("complaints.created_at <= ?", 15.days.ago)
                          .where(user_complaints: { role: "forwarded_to" }).where(status: ["open", nil])

    if complaints.empty?
      Rails.logger.info "📭 No complaints older than 15 days found with role 'forwarded_to'."
    end

    complaints.find_each do |complaint|
      forwarded_to_user = complaint.user_complaints.find_by(role: "forwarded_to")&.user
      if forwarded_to_user.present?
        ComplaintMailer.reminder_email(forwarded_to_user, complaint).deliver_later
      end
    end
  end
end
