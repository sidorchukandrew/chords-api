class AdminTeamsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin
    before_action :set_team, only: [:show]

    def index
        @teams = Team.all
        @teams = @teams.map {|team| team.to_hash}

        render json: @teams
    end

    def show
        render json: @team.to_hash
    end

    private
    def set_team
        @team = Team.find(params[:id])
    end
end
