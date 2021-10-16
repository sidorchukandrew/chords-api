# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  before_action :can_view_songs, only: %i[index show]
  before_action :can_edit_songs, only: %i[update add_themes remove_themes add_genres remove_genres]
  before_action :can_delete_songs, only: [:destroy]
  before_action :can_add_songs, only: [:create]

  before_action :set_song, only: %i[update destroy add_themes remove_themes add_genres remove_genres]

  # GET /songs
  def index
    @songs = Song.includes(:binders).where(team_id: params[:team_id])
    @songs = @songs.where('name ILIKE ?', "%#{params[:name]}%") if name_passed?

    render json: @songs, include: :binders
  end

  # GET /songs/1
  def show
    @song = Song.includes(:themes, :genres, :binders).find(params[:id])
    @format = Format.for_song_and_user(@song, @current_user).first

    if !@format.present?
      puts 'Using any format on the song'
      @format = Format.for_song(@song).first unless @format.present?
    end

    song = @song.as_json
    song['format'] = @format || default_format
    song['themes'] = @song.themes.as_json
    song['binders'] = @song.binders.as_json
    song['genres'] = @song.genres.as_json

    render json: song
  end

  # POST /songs
  def create
    @song = Song.new(song_params)
    @song.source = 'App'

    if @song.save
      render json: @song, status: :created, location: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      render json: @song, include: %i[themes genres binders]
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
    @song = if params[:id]
              Song.where(team_id: params[:team_id], id: params[:id]).first
            else
              Song.where(team_id: params[:team_id], id: params[:song_id]).first
            end
  end

  # Only allow a list of trusted parameters through.
  def song_params
    params.permit(%i[name team_id bpm artist meter original_key content transposed_key])
  end

  def default_format
    {
      font: 'Roboto Mono',
      font_size: 18,
      bold_chords: false,
      italic_chords: false
    }
  end

  def can_view_songs
    return_forbidden unless @current_member.can? VIEW_SONGS
  end

  def can_edit_songs
    return_forbidden unless @current_member.can? EDIT_SONGS
  end

  def can_delete_songs
    return_forbidden unless @current_member.can? DELETE_SONGS
  end

  def can_add_songs
    return_forbidden unless @current_member.can? ADD_SONGS
  end
end
