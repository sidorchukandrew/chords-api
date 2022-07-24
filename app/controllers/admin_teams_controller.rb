class AdminTeamsController < ApplicationController
    before_action :authenticate_user!, :authenticate_admin, :set_default_response_format
    before_action :set_team, only: [:memberships, :songs_index, :binders]

    def index
        @teams = Team.all
        @teams = @teams.map {|team| team.to_hash}

        render json: @teams
    end

    def show
        @team = Team.includes([:subscription, :roles, memberships: [:user]]).find(params[:id])
    end

    def memberships
        @memberships = @team.memberships.map do |membership|
            membership.to_hash
        end
        
        render json: @memberships
    end

    def songs_index
        @songs = @team.songs
        
        render json: @songs
    end

    def binders
        @binders = @team.binders
        
        render json: @binders, include: [:songs]
    end

    def setlists
        @setlists = Setlist.includes(:songs).where(team_id: params[:id])
    end

    private
    def set_team
        @team = Team.find(params[:id])
    end

    def set_default_response_format
        request.format = :json
    end
end
