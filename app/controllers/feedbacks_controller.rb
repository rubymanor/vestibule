class FeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def create
    @talk = Talk.find(params[:talk_id])
    @new_feedback = @talk.feedbacks.build(params[:feedback])
    @new_feedback.user = current_user
    if @new_feedback.save
      redirect_to talk_path(@talk)
    else
      render 'talks/show'
    end
  end
end
