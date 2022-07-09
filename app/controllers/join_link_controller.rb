class JoinLinkController < ApplicationController
  before_action :set_team
  before_action :authenticate_user!, only: [:join]

  def find_by_join_link
    render json: @team, include: [users: { except: [:pco_access_token, :pco_refresh_token, :pco_token_expires_at] }]
  end

  def join
    @current_user.join_team(@team.id)  
  end

  private

  def set_team
    join_link = params[:code]
    @team = Team.find_by(join_link: join_link, join_link_enabled: true)

    return render status: :not_found unless @team.present?
  end
end
