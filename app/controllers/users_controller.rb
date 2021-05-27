class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def me
        render json: current_user
    end

    def update_me
        @user = User.find(current_user.id)

        @user.update(user_params)

        render json: @user
    end

    private
    def user_params
        params.require(:user).permit([:first_name, :last_name])
    end
end
