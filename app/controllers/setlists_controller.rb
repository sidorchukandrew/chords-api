class SetlistsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_team
  before_action :set_setlist, only: [:show, :update, :destroy, :add_songs, :remove_songs, :update_scheduled_song]

  # GET /setlists
  def index
    @setlists = Setlist.includes(:songs).where(team_id: params[:team_id])

    render json: @setlists, include: :songs
  end

  # GET /setlists/1
  def show
    songs_with_positions = @setlist.songs_with_positions
    @setlist = @setlist.as_json
    @setlist["songs"] = songs_with_positions
    render json: @setlist
  end

  # POST /setlists
  def create
    @setlist = Setlist.new(setlist_params)

    if @setlist.save
      render json: @setlist, status: :created, location: @setlist
    else
      render json: @setlist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /setlists/1
  def update
    if @setlist.update(setlist_params)
      render json: @setlist
    else
      render json: @setlist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /setlists/1
  def destroy
    @setlist.destroy
  end

  # POST /setlists/1/songs
  def add_songs
    added_songs = @setlist.add_songs(params[:song_ids])

    render json: added_songs
  end

  # DELETE /setlists/1/songs
  def remove_songs
    @setlist.remove_songs(params[:song_ids])
  end

  # PUT /setlists/1/songs/1
  def update_scheduled_song
    @setlist.update_song_order(params[:song_id], params[:position])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setlist
      id_to_find_by = params[:setlist_id] ? params[:setlist_id] : params[:id]
      @setlist = Setlist.find(id_to_find_by)
    end

    # Only allow a list of trusted parameters through.
    def setlist_params
      params.require(:setlist).permit([:id, :name, :scheduled_date, :team_id, :song_ids])
    end
end