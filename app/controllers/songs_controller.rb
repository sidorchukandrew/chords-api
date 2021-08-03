class SongsController < ApplicationController
  before_action :set_song, only: [:update, :destroy, :add_themes, :remove_themes, :add_genres, :remove_genres]
  before_action :authenticate_user!

  # GET /songs
  def index
    @songs = Song.includes(:binders).where(team_id: params[:team_id])
    @songs = @songs.where("name ILIKE ?", "%#{params[:name]}%") if name_passed?

    render json: @songs, include: :binders
  end

  # GET /songs/1
  def show
    @song = Song.includes(:themes, :genres, :binders).find(params[:id])
    @format = Format.for_song_and_user(@song, @current_user).first

    song = @song.as_json
    song["format"] = @format ? @format : default_format
    song["themes"] = @song.themes.as_json
    song["binders"] = @song.binders.as_json
    song["genres"] = @song.genres.as_json

    render json: song
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
      params.require(:song).permit([:name, :team_id, :bpm, :artist, :meter, :key, :content, :font, :font_size, :bold_chords, :italic_chords])
    end

    def default_format
      format = {
        font: "Courier New",
        font_size: 18,
        bold_chords: false,
        italic_chords: false
      }
    end
end
