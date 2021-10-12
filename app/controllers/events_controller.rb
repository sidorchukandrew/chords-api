class EventsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team, :validate_subscription
  before_action :can_view_events, only: %i[index show]
  before_action :can_add_events, only: [:create]
  before_action :can_delete_events, only: [:destroy]
  before_action :set_event, only: %i[show destroy]

  def index
    @events = Event.includes(:memberships).where(team_id: params[:team_id])
    render json: @events, include: { memberships: { include: :user } }
  end

  def show
    @event = Event.find_by(team_id: params[:team_id], id: params[:id])
    render json: @event
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, include: { memberships: { include: :user } }
    else
      render json: @event.errors.full_messages
    end
  end

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find_by(team_id: params[:team_id], id: params[:id])
  end

  def event_params
    params.permit([:title, :description, :color, :start_time, :end_time, { membership_ids: [] }, :reminders_enabled, 
                   :reminder_date, :team_id])
  end

  def validate_subscription
    return_forbidden unless @current_subscription.calendar_enabled?
  end

  def can_view_events
    return_forbidden unless @current_member.can? VIEW_EVENTS
  end

  def can_edit_events
    return_forbidden unless @current_member.can? EDIT_EVENTS
  end

  def can_delete_events
    return_forbidden unless @current_member.can? DELETE_EVENTS
  end

  def can_add_events
    return_forbidden unless @current_member.can? ADD_EVENTS
  end
end
