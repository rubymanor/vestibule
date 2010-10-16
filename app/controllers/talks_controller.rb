class TalksController < ApplicationController
  def index
    @talks = Talk.order('created_at DESC')
  end

  def show
    @talk = Talk.find(params[:id])
  end
end
