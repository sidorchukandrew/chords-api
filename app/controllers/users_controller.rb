class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:make_admin, :remove_admin, :update_membership, :remove_membership]
    
    def me
        render json: @current_user.to_hash
    end

    def membership
        @membership = @current_user.memberships.find_by_team_id(params[:team_id])
        render json: @membership
    end

    def update_membership
        if has_admin_params?
            unless @current_user.is_admin?(params[:team_id])
                return render json: {message: "You need to be an admin of this team to perform this operation"}, status: :unauthorized
            end
        end

        @membership = @user.memberships.find_by_team_id(params[:team_id])
        @membership.update(membership_params)

        render json: @membership
    end

    def remove_membership
        if @current_user.is_admin?(params[:team_id])
            @user.leave_team(params[:team_id])
        else
            render json: {message: "You need to be an admin of this team to perform this operation"}, status: :unauthorized
        end
    end

    def show_membership
        @membership = Membership.where(team_id: params[:team_id]).where(user_id: params[:id]).first
        if @membership.present?
            render json: @membership.to_hash
        else
            render status: 404
        end
    end

    def update_me
        @user = User.find(current_user.id)

        @user.update(user_params)

        render json: @user
    end

    private
    def set_user
      if params[:id]
        @user = User.find(params[:id])
      end
    end

    def user_params
        params.require(:user).permit([:first_name, :last_name])
    end

    def has_admin_params?
        params.has_key?(:is_admin)
    end

    def membership_params
        params.permit([:is_admin, :position])
    end
end
