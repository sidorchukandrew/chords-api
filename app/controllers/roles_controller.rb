class RolesController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  before_action :can_view_roles, only: [:index, :show]
  before_action :can_edit_roles, only: [:add_permission, :remove_permission, :update]
  before_action :can_assign_roles, only: [:assign_role_bulk]
  before_action :can_add_roles, only: [:create]
  before_action :can_delete_roles, only: [:destroy]
  before_action :set_role, only: [:show, :add_permission, :remove_permission, :update, :assign_role_bulk, :destroy]

  def index
    @roles = Role.where(team_id: params[:team_id]).includes(:permissions, :memberships)

    render json: @roles, include: [:permissions, :memberships]
  end

  def show
    render json: @role, include: { permissions: {}, memberships: { include: {
      user: { except: [:pco_access_token, :pco_refresh_token, :pco_token_expires_at, :allow_password_change] }
    } } }
  end

  def update
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def add_permission
    @role.add_permission params[:name]
    render json: @role, include: [:permissions, :memberships]
  end

  def remove_permission
    @role.remove_permission params[:name]

    render json: @role, include: [:permissions, :memberships]
  end

  def assign_role_bulk
    Membership.find(params[:membership_ids])
    Membership.where(id: params[:membership_ids]).update_all(role_id: @role.id)

    @memberships = Membership.where(id: params[:membership_ids]).includes(:role, :user)
    render json: @memberships, include: [:role, 
      { user: { except: [:pco_access_token, :pco_refresh_token, :pco_token_expires_at, :allow_password_change] } }
    ]
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
  end

  private

  def role_params
    params.permit([:name, :description, :team_id])
  end

  def set_role
    @role = Role.find_by!(team_id: params[:team_id], id: params[:id])
  end

  def can_view_roles
    return_forbidden unless @current_member.can? VIEW_ROLES
  end

  def can_edit_roles
    return_forbidden unless @current_member.can? EDIT_ROLES
  end

  def can_assign_roles
    return_forbidden unless @current_member.can? ASSIGN_ROLES
  end

  def can_add_roles
    return_forbidden unless @current_member.can? ADD_ROLES
  end

  def can_delete_roles
    return_forbidden unless @current_member.can? DELETE_ROLES
  end

end
