class SetlistsController < ApplicationController

  before_action :authenticate_user!, :authenticate_team
  before_action :can_add_setlists, only: [:create]
  before_action :can_edit_setlists, only: [:update, :add_songs, :remove_songs, :update_scheduled_song]
  before_action :can_delete_setlists, only: [:destroy]
  before_action :can_view_setlists, only: [:index, :show]
  before_action :set_setlist, only: [:show, :update, :destroy, :add_songs, :remove_songs, :update_scheduled_song]

  # GET /setlists
  def index
    @setlists = Setlist.includes(:songs).where(team_id: params[:team_id])
    @setlists = @setlists.where('name ILIKE ?', "%#{params[:name]}%") if name_passed?
    render json: @setlists, include: :songs
  end

  # GET /setlists/1
  def show
    songs_with_positions = @setlist.songs_with_positions(@current_user, @current_member)
    @setlist = @setlist.as_json
    @setlist['songs'] = songs_with_positions
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
    added_songs = @setlist.add_songs(params[:song_ids], @current_user, @current_member)

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
    id_to_find_by = params[:setlist_id] || params[:id]
    @setlist = Setlist.find_by!(id: id_to_find_by, team_id: params[:team_id])
  end

  # Only allow a list of trusted parameters through.
  def setlist_params
    params.require(:setlist).permit([:id, :name, :scheduled_date, :team_id, :song_ids])
  end

  def can_view_setlists
    return_forbidden unless @current_member.can? VIEW_SETLISTS
  end

  def can_edit_setlists
    return_forbidden unless @current_member.can? EDIT_SETLISTS
  end

  def can_delete_setlists
    return_forbidden unless @current_member.can? DELETE_SETLISTS
  end

  def can_add_setlists
    return_forbidden unless @current_member.can? ADD_SETLISTS
  end
end
