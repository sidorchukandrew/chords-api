class TracksController < ApplicationController
    before_action :authenticate_user!, :authenticate_team
    before_action :can_edit_songs, only: [:destroy, :create_bulk]
    before_action :set_song, only: [:create_bulk]
    before_action :set_track, only: [:destroy]

    def index
        @tracks = Track.where(team_id: params[:team_id], song_id: params[:id])
        render json: @tracks
    end

    def create_bulk
        tracks = Track.create!(tracks_params) do |t|
            t.song = @song
            t.team_id = params[:team_id]
        end

        render json: tracks
    end

    def destroy
        @track.destroy
    end

    private

    def set_song
        @song = Song.find_by!(team_id: params[:team_id], id: params[:song_id])
    end

    def set_track
        @track = Track.find_by!(team_id: params[:team_id], song_id: params[:song_id], id: params[:id])
    end

    def tracks_params
        params.require(:_json).map do |track|
            track.permit(:url, :source, :external_id, :artwork_url, :name)
        end
    end

    def can_edit_songs
        return_forbidden unless @current_member.can? EDIT_SONGS
    end
end
