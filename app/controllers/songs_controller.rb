class SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /songs
  def index
    @songs = Song.includes(:binders).where(team_id: params[:team_id])

    render json: @songs, include: :binders
  end

  # GET /songs/1
  def show
    render json: @song
  end

  # POST /songs
  def create
    @song = Song.new(song_params)

    if @song.save
      render json: @song, status: :created, location: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      render json: @song
    else  
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.where(team_id: params[:team_id], id: params[:id]).first
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit([:name, :team_id, :bpm, :artist, :meter, :key])
    end
end
