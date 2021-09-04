class AdminUsersController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin
    
    def index
        @users = User.all

        @users = @users.map do |user|
            user.to_hash
        end

        render json: @users
    end
end
