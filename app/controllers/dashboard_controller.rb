class DashboardController < ApplicationController
  before_action :authenticate_user!, :authenticate_team

  def show
    @todays_setlists = Setlist.includes(:scheduled_songs).where(team_id: params[:team_id], scheduled_date: today)

    render json: { todays_setlists: @todays_setlists }, include: :scheduled_songs
  end

  private

  def today
    Time.now.in_time_zone(@current_user.timezone)
  end

end
