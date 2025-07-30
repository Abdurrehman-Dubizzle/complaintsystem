class UsersController < ApplicationController
  include AdminAuthorization

  #debugger
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:show, :destroy, :user_complaints_count]

  before_action :authenticate_user!, only: [ :dashboard]

  before_action :authorize_admin!, only: [:admin_dashboard]



  def admin_dashboard
    authorize! :access, :admin_dashboard
    @complaint_count = Complaint.count
    @user_count = User.count
    @content_count = ComplainMessage.count
  end

  def dashboard
    @user = current_user
    user_ids = @user.subtree_ids

    @complaints = Complaint
                    .joins(:user_complaints)
                    .where(user_complaints: { user_id: user_ids }, complaints: { status: ["open", nil]})
                    .distinct
                    .includes(:user_complaints, :complain_messages)

    @new_message = ComplainMessage.new
  end



  def user_complaints_count #get each user counts
    render json: {
      user: @user,
      complaints_summary: {
        sent: @user.sent_complaints.count,
        received: @user.received_complaints.count,
        forwarded_to: @user.forwarded_complaints.count
      }
    }
  end

  def new

  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user
  end

  def destroy
    if @user.destroy
      render json: { message: "User deleted successfully." }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private



  def set_user
    #debugger
    puts params[:id]
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :designation)
  end

end
