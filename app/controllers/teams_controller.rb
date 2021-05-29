class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_team, except: [:create, :index]
  before_action :set_team, only: [:update, :destroy]

  # GET /teams
  def index
    @teams = User.find(@current_user.id).teams

    render json: @teams
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:team_id])
    @memberships = @team.memberships.collect {|membership| membership.user}.flatten
    render json: {team: @team, members: @memberships}
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    
    if @team.save
      @team.make_admin(@current_user)
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
      @team = User.find(@current_user.id).teams.find(params[:team_id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit([:name, :team_id])
    end
end
