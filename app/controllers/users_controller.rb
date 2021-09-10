class UsersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user, only: %i[make_admin remove_admin update_membership remove_membership]

  def me
    render json: @current_user.to_hash
  end

  def membership
    @membership = @current_user.memberships.find_by_team_id(params[:team_id])
    render json: @membership, include: { role: { include: :permissions } }
  end

  def update_membership
    if admin_params? && !@current_user.is_admin?(params[:team_id])
      return render json: { message: 'You need to be an admin of this team to perform this operation' },
                            status: :unauthorized
    end

    @membership = @user.memberships.find_by_team_id(params[:team_id])
    @membership.update(membership_params)
    render json: @membership
  end

  def remove_membership
    if @current_user.is_admin?(params[:team_id])
      @user.leave_team(params[:team_id])
    else
      render json: { message: 'You need to be an admin of this team to perform this operation' },
                      status: :unauthorized
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
    @user = User.find(params[:id]) if params[:id]
  end

  def user_params
    params.require(:user).permit(%i[first_name last_name])
  end

  def admin_params?
    params.key?(:is_admin)
  end

  def membership_params
    params.permit(%i[is_admin position])
  end
end
