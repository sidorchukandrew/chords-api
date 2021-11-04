class TeamMembershipsController < ApplicationController

  before_action :authenticate_user!, :authenticate_team

  def index
    @memberships = Membership.where(team_id: params[:team_id]).includes(:role, :user)
    render json: @memberships, include: [:role, { user: { except: [:pco_access_token, :pco_refresh_token, :pco_token_expires_at] } }]
  end
end
