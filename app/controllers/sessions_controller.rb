class SessionsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team, :validate_subscription

  def index
    @sessions = Session.includes(:user).where(team_id: params[:team_id], setlist_id: params[:setlist_id], status: "ACTIVE")
    render json: @sessions, include: [:user]
  end

  def update
  end

  def create
    @session = Session.new(session_params)
    @session.user = @current_user
    @session.team = @current_member.team

    if @session.save
      render json: @session
    else
      render json: @session.errors, status: :unprocessable_entity
    end
  end

  private
  def session_params
    params.permit(:setlist_id, :team_id, :status)
  end

  def validate_subscription
    return_forbidden unless @current_subscription.sessions_enabled?
  end
end
