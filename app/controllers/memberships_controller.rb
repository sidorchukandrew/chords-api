class MembershipsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  before_action :can_assign_roles, only: [:assign_role]
  before_action :set_role, :set_membership, only: [:assign_role]

  def assign_role
    @membership.role = @role
    @membership.save

    render json: @membership, include: [:role, :user]
  end

  private
  
  def can_assign_roles
    return_forbidden unless @current_member.can? ASSIGN_ROLES
  end

  def set_role
    @role = Role.find_by!(team_id: params[:team_id], name: params[:name])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
