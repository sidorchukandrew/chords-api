class TeamMembershipsController < ApplicationController

  before_action :authenticate_user!, :authenticate_team

  def index
    @memberships = Membership.where(team_id: params[:team_id]).includes(:role, :user)
    render json: @memberships, include: [:role, :user]
  end
end
