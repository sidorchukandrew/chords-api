require 'oauth2'
require 'pco_api'
include PcoUtils

class PlanningCenterController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_team, only: [:import]

    def disconnect
        @current_user.pco_access_token = nil
        @current_user.pco_refresh_token = nil
        @current_user.pco_token_expires_at = nil
        @current_user.save
    end
    
    def auth
        if params[:code]
            token = client.auth_code.get_token(params[:code], redirect_uri: "#{ENV['WEB_APP_BASE_URL']}/import/pco_redirect")
            @current_user.add_pco_token(token)
        end
    end

    def index
        begin
            @songs = api.services.v2.songs.get(query_params)
        rescue
            @current_user.refresh_pco_token
            @songs = api.services.v2.songs.get(query_params)
        end

        @songs = @songs["data"].map do |song|
            song_params = {
                id: song["id"],
                title: song["attributes"]["title"],
                author: song["attributes"]["author"]
            }
            song_params
        end

        render json: @songs
    end

    def import
        song_ids = params[:songs]

        song_ids.each do |song_id|
            pco_song = api.services.v2.songs[song_id].get
            arrangements = api.services.v2.songs[song_id].arrangements.get

            song = Song.new do |song|
                song.name = pco_song["data"]["attributes"]["title"]
                song.artist = pco_song["data"]["attributes"]["author"]
                song.content = arrangements["data"][0]["attributes"]["chord_chart"]
                song.bpm = arrangements["data"][0]["attributes"]["bpm"]
                song.meter = arrangements["data"][0]["attributes"]["meter"]
                song.team_id = params[:team_id]
                song.source = "Planning Center"
            end

            song.save
        end
    end

    private
    
    def client
        OAuth2::Client.new(OAUTH_APP_ID, OAUTH_SECRET, site: API_URL)
    end

    def query_params
        {
            "offset" => params[:offset],
            "where[title]" => params[:query]
        }.compact
    end

    def api
        PCO::API.new(oauth_access_token: @current_user.pco_access_token, url: API_URL)
    end
end
