class TalksController < ApplicationController
  before_filter :authenticate_account!, :except => [:index, :show]

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
    @talk = current_account.talks.create!(params[:talk])
    redirect_to talks_path
  end
end
