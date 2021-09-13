class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_team, only: [:update_membership, :remove_membership, :show_membership]
  before_action :can_remove_members, only: [:remove_membership]
  before_action :set_user, only: %i[make_admin remove_admin update_membership remove_membership]

  def me
    render json: @current_user.to_hash
  end

  def membership
    @membership = @current_user.memberships.find_by_team_id(params[:team_id])
    render json: @membership, include: { role: { include: :permissions } }
  end

  def update_membership
    @membership = @user.memberships.find_by_team_id(params[:team_id])
    @membership.update(membership_params)
    render json: @membership
  end

  def remove_membership
    @user.leave_team(params[:team_id])
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

  def membership_params
    params.permit(%i[position])
  end

  def can_remove_members
    return_forbidden unless @current_member.can? REMOVE_MEMBERS
  end
end
