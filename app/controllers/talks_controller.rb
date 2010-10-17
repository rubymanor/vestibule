class TalksController < ApplicationController
  def index
    @talks = Talk.order('created_at DESC')
  end

  def show
    @talk = Talk.find(params[:id])
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(params[:talk])
    if @talk.save
      redirect_to talks_path
    else
      render :action => 'new'
    end
  end
end
