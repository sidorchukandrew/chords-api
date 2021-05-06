class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /teams
  def index
    @teams = User.find(current_user.id).teams

    render json: @teams
  end

  # GET /teams/1
  def show
    render json: @team
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    @team.users << current_user

    if @team.save
      render json: @team, status: :created, location: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = User.find(current_user.id).teams.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit([:name])
    end
end
