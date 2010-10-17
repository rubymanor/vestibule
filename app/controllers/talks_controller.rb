class TalksController < ApplicationController
  def index
    @talks = Talk.order('updated_at DESC')
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

  def edit
    @talk = Talk.find(params[:id])
  end

  def update
    @talk = Talk.find(params[:id])
    @talk.attributes = params[:talk]
    if @talk.save
      redirect_to talk_path(@talk)
    else
      render :action => 'edit'
    end
  end
end
