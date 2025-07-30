class StageResponsesController < ApplicationController


  def approve
    stage = ComplaintStage.find(params[:id])
    stage.update!(
      reviewer_approved: true,
      completed: true,
      completed_at: Time.current,
      forwarded_decision: params[:forwarded_decision]
    )

    redirect_to complaint_path(stage.complaint_id), notice: "Stage approved."
  end



  def create
    complaint_stage = ComplaintStage.find(params[:complaint_stage_id])
    user_id = params[:user_id]


    params[:responses]&.each do |question_id, answer|
      StageResponse.create!(
        complaint_stage_id: complaint_stage.id,
        stage_question_id: question_id,
        user_id: user_id,
        answer_text: answer
      )
    end

    complaint_stage.update!(started_at: Time.current)

    redirect_to complaint_path(complaint_stage.complaint_id), notice: "Stage completed successfully."
  end
end
