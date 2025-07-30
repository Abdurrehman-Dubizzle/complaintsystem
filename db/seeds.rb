# db/seeds.rb

# === Clear Old Data ===
UserComplaint.destroy_all
ComplainMessage.destroy_all
Complaint.destroy_all
User.destroy_all
StageResponse.destroy_all
ComplaintStage.destroy_all
StageQuestion.destroy_all
Stage.destroy_all
StageTemplate.destroy_all

# === HARASSMENT FLOW ===
harassment_template = StageTemplate.create!(category_type: "harassment", name: "Harassment Handling Flow")
har_stage1 = harassment_template.stages.create!(title: "Initial Intake", order: 1, description: "Collect basic details from the user.")
har_stage1.stage_questions.create!([
                                     { question_text: "Please describe the incident.", question_type: "text" },
                                     { question_text: "Was it physical or verbal?", question_type: "multiple_choice" },
                                     { question_text: "Do you feel unsafe?", question_type: "tick_cross" }
                                   ])
har_stage2 = harassment_template.stages.create!(title: "Investigation", order: 2, description: "Internal team investigates the complaint.")
har_stage2.stage_questions.create!([
                                     { question_text: "Was evidence provided?", question_type: "tick_cross" },
                                     { question_text: "Investigator's notes", question_type: "text" }
                                   ])

# === MISCONDUCT FLOW ===
misconduct_template = StageTemplate.create!(category_type: "misconduct", name: "Misconduct Review Flow")
mis_stage1 = misconduct_template.stages.create!(title: "Preliminary Report", order: 1, description: "Capture misconduct report details.")
mis_stage1.stage_questions.create!([
                                     { question_text: "Describe the misconduct.", question_type: "text" },
                                     { question_text: "Was it witnessed?", question_type: "tick_cross" }
                                   ])
mis_stage2 = misconduct_template.stages.create!(title: "Follow-Up Discussion", order: 2, description: "Notes from discussion with involved parties.")
mis_stage2.stage_questions.create!([
                                     { question_text: "Discussion summary", question_type: "text" },
                                     { question_text: "Further action needed?", question_type: "tick_cross" }
                                   ])

# === BULLYING FLOW ===
bullying_template = StageTemplate.create!(category_type: "bullying", name: "Bullying Escalation Flow")
bully_stage1 = bullying_template.stages.create!(title: "Incident Logging", order: 1, description: "Victim logs the incident details.")
bully_stage1.stage_questions.create!([
                                       { question_text: "What happened?", question_type: "text" },
                                       { question_text: "Was this repeated behavior?", question_type: "tick_cross" }
                                     ])
bully_stage2 = bullying_template.stages.create!(title: "Peer Witness Review", order: 2, description: "Statements from peers or witnesses.")
bully_stage2.stage_questions.create!([
                                       { question_text: "Any peer witnessed this?", question_type: "tick_cross" },
                                       { question_text: "Peer notes", question_type: "text" }
                                     ])

# === FRAUD FLOW ===
fraud_template = StageTemplate.create!(category_type: "fraud", name: "Fraud Incident Flow")
fraud_stage1 = fraud_template.stages.create!(title: "Allegation Report", order: 1, description: "User describes the fraud scenario.")
fraud_stage1.stage_questions.create!([
                                       { question_text: "Detail the fraud allegation", question_type: "text" },
                                       { question_text: "Do you have any documents?", question_type: "tick_cross" }
                                     ])
fraud_stage2 = fraud_template.stages.create!(title: "Financial Review", order: 2, description: "Finance team reviews related transactions.")
fraud_stage2.stage_questions.create!([
                                       { question_text: "Any anomalies found?", question_type: "tick_cross" },
                                       { question_text: "Comments by finance team", question_type: "text" }
                                     ])

# === USERS ===
admin = User.create!(email: "ar@example.com", password: "123456", designation: "admin")
director = User.create!(email: "dir@example.com", password: "123456", designation: "Director")
manager = User.create!(email: "man@example.com", password: "123456", designation: "Manager", parent: director)
staff   = User.create!(email: "emp@example.com", password: "123456", designation: "Employee", parent: manager)

puts "Hierarchy:"
puts "Director: #{director.email}"
puts " └── Manager: #{manager.email}"
puts "     └── Staff: #{staff.email}"

# === COMPLAINTS ===
c1 = Complaint.create!(category_type: "harassment")
UserComplaint.create!(user: staff, complaint: c1, role: "complainer")
UserComplaint.create!(user: manager, complaint: c1, role: "against")
UserComplaint.create!(user: director, complaint: c1, role: "forwarded_to")

c2 = Complaint.create!(category_type: "misconduct")
UserComplaint.create!(user: manager, complaint: c2, role: "complainer")
UserComplaint.create!(user: staff, complaint: c2, role: "against")
UserComplaint.create!(user: director, complaint: c2, role: "forwarded_to")

c3 = Complaint.create!(category_type: "bullying")
UserComplaint.create!(user: staff, complaint: c3, role: "complainer")
UserComplaint.create!(user: director, complaint: c3, role: "against")

c4 = Complaint.create!(category_type: "fraud")
UserComplaint.create!(user: manager, complaint: c4, role: "complainer")
UserComplaint.create!(user: director, complaint: c4, role: "forwarded_to")

c5 = Complaint.create!(category_type: "abuse")
UserComplaint.create!(user: director, complaint: c5, role: "complainer")

c6 = Complaint.create!(category_type: "lateness")
UserComplaint.create!(user: staff, complaint: c6, role: "against")
UserComplaint.create!(user: manager, complaint: c6, role: "complainer")

c7 = Complaint.create!(category_type: "performance")
UserComplaint.create!(user: staff, complaint: c7, role: "complainer")
UserComplaint.create!(user: manager, complaint: c7, role: "against")
UserComplaint.create!(user: director, complaint: c7, role: "forwarded_to")

c8 = Complaint.create!(category_type: "corruption")
UserComplaint.create!(user: staff, complaint: c8, role: "complainer")
UserComplaint.create!(user: director, complaint: c8, role: "against")

puts "✅ Seeded 8 complaints with realistic role combinations."

# === MESSAGES ===
ComplainMessage.create!(complaint: c1, user: staff, content: "This is unacceptable.")
ComplainMessage.create!(complaint: c1, user: director, content: "Noted, we will review.")
ComplainMessage.create!(complaint: c2, user: manager, content: "Raising this due to repeated issues.")
ComplainMessage.create!(complaint: c2, user: director, content: "Thanks, acknowledged.")

puts "✅ Seeded users, hierarchy, stages, templates, complaints, and messages!"