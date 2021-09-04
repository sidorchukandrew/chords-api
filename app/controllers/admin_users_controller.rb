class AdminUsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin
    before_action :set_user, only: [:show, :memberships]
    
    def index
        @users = User.all

        @users = @users.map do |user|
            user.to_hash
        end

        render json: @users
    end

    def show
        render json: @user.to_hash
    end

    def memberships
        render json: @user.memberships, include: [:team]
    end

    private 
    def set_user
        @user = User.find(params[:id])
        unless @user.present?
            return render status: 404
        end
    end
end
