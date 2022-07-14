class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_team, except: [:create, :index]
  before_action :can_edit_team?, only: [:update]
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
      @team.subscribe(params[:plan])
      render json: @team, status: :created, location: @team, include: [:subscription]
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    return render status: :forbidden if params.key?(:join_link_enabled) && !can_add_members?
    
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
    params.require(:team).permit([:name, :team_id, :join_link_enabled])
  end

  def can_add_members?
    @current_member.can? ADD_MEMBERS
  end

  def can_edit_team?
    return_forbidden unless @current_member.can? EDIT_TEAM
  end
end
