class ComplaintMailer < ApplicationMailer
  def reminder_email(user, complaint)
    @user = user
    @complaint = complaint
    mail(to: @user.email, subject: "Reminder: Complaint is pending for over 15 days")
  end
end
