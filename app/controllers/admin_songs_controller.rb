class AdminSongsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_default_response_format

  def index
    @songs = Song.all
  end

  def show
    @song = Song.includes(:binders, :genres, :themes, :setlists, :formats, :notes, :tracks, :capos).find(params[:id])
    render json: @song, include: [:binders, :genres, :themes, :setlists, :formats, :notes, :tracks, :capos]
  end

  private
  def set_default_response_format
    request.format = :json
  end
end
