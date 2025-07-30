class ComplainMessagesController < ApplicationController
  before_action :set_message, only: [:show, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @messages = ComplainMessage.all

  end

  def show
    # set_message already sets the message
  end

  def create
    @message = ComplainMessage.new(message_params)

    if @message.save
      redirect_to dashboard_path(@message.complaint_id), notice: "Comment added."
    else
      redirect_to dashboard_path(@message.complaint_id), alert: "Comment not saved."
    end
  end

  def destroy

    # can only delete if the user commented it
    if current_user && current_user.id == @message.user_id or current_user.admin?
      @message.destroy
      redirect_back(fallback_location: root_path)
    else
      redirect_to dashboard_path(@message.complaint_id), alert: "Unauthorized to delete."
    end
  end

  private

  def set_message
    @message = ComplainMessage.find(params[:id])
  end

  def message_params
    params.require(:complain_message).permit(:user_id, :complaint_id, :content)
  end
end
