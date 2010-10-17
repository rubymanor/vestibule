class TalksController < ApplicationController
  before_filter :fetch_talk, :only => [:show, :edit, :update]

  def index
    @talks = Talk.order('updated_at DESC')
  end

  def show
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
  end

  def update
    @talk.attributes = params[:talk]
    if @talk.save
      redirect_to talk_path(@talk)
    else
      render :action => 'edit'
    end
  end
  
  protected
  
  def fetch_talk
    @talk = Talk.find(params[:id])
  end
end
