class TalksController < ApplicationController
  before_filter :authenticate_account!

  def index
    @talks = Talk.all
  end

  def show
    @talk = Talk.find(params[:id])
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(params[:talk])
    @talk.save!
    redirect_to talks_path
  end
end
