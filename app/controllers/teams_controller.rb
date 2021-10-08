class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_team, except: [:create, :index]
  before_action :set_team, only: [:update, :destroy]

  # GET /teams
  def index
    @teams = User.find(@current_user.id).teams
    @teams = @teams.map do |team|
      team.with_image
    end
    render json: @teams
  end

  # GET /teams/1
  def show
    @team = Team.includes(:memberships, :subscription).find(params[:team_id])
    members = @team.members
    
    render json: { team: @team.with_image, members: members, subscription: @team.subscription }
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    
    if @team.save
      @team.add_default_roles
      @team.make_admin(@current_user)
      @team.subscribe(@current_user, params[:plan])
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
