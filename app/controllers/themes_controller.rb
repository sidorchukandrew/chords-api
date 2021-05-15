class ThemesController < ApplicationController
  before_action :authenticate_user!

  def index
    @themes = Theme.where(team_id: params[:team_id])
    render json: @themes
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      render json: @theme, status: :created
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  private
  def theme_params
    params.require(:theme).permit([:name, :team_id])
  end
end
