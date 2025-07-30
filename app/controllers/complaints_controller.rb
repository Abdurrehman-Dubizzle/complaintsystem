class ComplaintsController < ApplicationController

  include AdminAuthorization

  before_action :set_complaint, only: [:show, :destroy]
  before_action :authenticate_user!, only: [:index]

  # PATCH /complaints/:id/resolve
  def resolve
    @complaint = Complaint.find(params[:id])
    @complaint.update(status: "resolved")
    redirect_to dashboard_path
  end

  def new
    @complaint = Complaint.new
    @users = User.all
  end

  def index
    #authorize! :access, :index
    user_ids = current_user.subtree_ids if current_user.has_children?

    base_query =
      if current_user.admin?
        Complaint.where(status: ["open", nil])
      elsif current_user.has_children?
        Complaint.joins(:user_complaints)
                 .where(user_complaints: { user_id: user_ids }, status: ["open", nil])
                 .distinct
      else
        Complaint.joins(:user_complaints)
                 .where(user_complaints: { user_id: current_user.id }, status: ["open", nil])
                 .distinct
      end

    @complaints = if params[:q].present?
                    Complaint.search(params[:q]).records & base_query.to_a
                  else
                    base_query
                  end
  end

  def show
    @complaint = Complaint.find(params[:id])
    @complain_messages = @complaint.complain_messages.includes(:user)
    @new_message = ComplainMessage.new
    @user_role = @complaint.user_complaints.find_by(user_id: current_user.id)&.role
    stages = @complaint.complaint_stages.includes(stage: :stage_questions).order('stages."order"')

    @current_stage = case @user_role
                     when "complainer"
                       stages.find do |s|
                         !s.completed && s.stage_responses.where(user_id: current_user.id).empty?
                       end

                     when "forwarded_to"
                       stages.find do |s|
                         !s.completed &&
                           s.reviewer_id == current_user.id &&
                           s.stage_responses.any? &&
                           !s.reviewer_approved
                       end

                     when "against"
                       stages.reverse.find do |s|
                         s.completed && s.reviewer_approved && s.forwarded_decision.present?
                       end

                     else
                       nil
                     end
  end

  def destroy
    authorize! :access, :destroy
    if @complaint.destroy
      render json: @complaint, status: :ok
    else
      render json: @complaint.errors, status: :unprocessable_entity
    end
  end

  def create
    Complaint.transaction do
      @complaint = Complaint.create!(complaints_params.except(:user_assignments))

      #create entries in UserComplaint bridge table
      if complaints_params[:user_assignments].present?
        complaints_params[:user_assignments].each do |assignment|
          UserComplaint.create!(
            user_id: assignment[:user_id],
            complaint_id: @complaint.id,
            role: assignment[:role]
          )
        end
      end

      # Assign complaint stages from template
      forwarded_to_user = @complaint.user_complaints.find_by(role: 'forwarded_to')&.user
      stage_template = StageTemplate.find_by(category_type: @complaint.category_type)
      if stage_template
        stage_template.stages.order(:order).each do |stage|
          ComplaintStage.create!(
            complaint: @complaint,
            stage: stage,
            completed: false,
            reviewer_id: forwarded_to_user&.id
          )
        end
      end

      render json: {
        complaint: @complaint,
        assigned_users: @complaint.user_complaints.includes(:user).as_json(include: :user)
      }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: e.message,
      full_errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  private

  def set_complaint
    @complaint = Complaint.find(params[:id])
  end

  def complaints_params
    params.require(:complaint).permit(
      :category_type,
      user_assignments: [:user_id, :role]
    )
  end



end
