class AdminTeamsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin
    before_action :set_team, only: [:show, :memberships, :songs, :binders, :setlists]

    def index
        @teams = Team.all
        @teams = @teams.map {|team| team.to_hash}

        render json: @teams
    end

    def show
        render json: @team.to_hash
    end

    def memberships
        @memberships = @team.memberships.map do |membership|
            membership.to_hash
        end
        
        render json: @memberships
    end

    def songs
        @songs = @team.songs
        
        render json: @songs
    end

    def binders
        @binders = @team.binders
        
        render json: @binders, include: [:songs]
    end

    def setlists
        @setlists = @team.setlists

        render json: @setlists, include: [:songs]
    end

    private
    def set_team
        @team = Team.find(params[:id])
    end
end
