class FilesController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_team, only: [:create_team_image]

    def create_user_image
        @current_user.profile_picture = params[:image]
        @current_user.save
        render json: @current_user.profile_picture.variant(resize_to_limit: [200, 200]).processed.url
    end

    def delete_user_image
        @current_user&.profile_picture&.purge
    end

    def create_team_image
        @team = Team.find(params[:team_id])
        @team.image.attach(params[:image])
        render json: @team.image.variant(resize_to_limit: [200, 200]).processed.url
    end

    def delete_team_image
        @team = Team.find(params[:team_id])
        @team.image&.purge
    end
end
