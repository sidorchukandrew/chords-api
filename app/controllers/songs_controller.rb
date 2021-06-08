class SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :destroy, :add_themes, :remove_themes, :add_genres, :remove_genres]
  before_action :authenticate_user!

  # GET /songs
  def index
    @songs = Song.includes(:binders).where(team_id: params[:team_id])

    render json: @songs, include: :binders
  end

  # GET /songs/1
  def show
    render json: @song, include: [:themes, :genres, :binders]
  end

  # POST /songs
  def create
    @song = Song.new(song_params)
    @song.source = "App"

    if @song.save
      render json: @song, status: :created, location: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      render json: @song, include: [:themes, :genres, :binders]
    else  
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy
  end

  def add_themes
    @song.add_themes(params[:theme_ids])

    render json: @song.themes.where(id: params[:theme_ids])
  end

  def remove_themes
    @song.remove_themes(params[:theme_ids])
  end

  def add_genres
    @song.add_genres(params[:genre_ids])

    render json: @song.genres.where(id: params[:genre_ids])
  end

  def remove_genres
    @song.remove_genres(params[:genre_ids])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      if params[:id]
        @song = Song.where(team_id: params[:team_id], id: params[:id]).first
      else
        @song = Song.where(team_id: params[:team_id], id: params[:song_id]).first
      end
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit([:name, :team_id, :bpm, :artist, :meter, :key, :content, :font, :font_size])
    end
end
