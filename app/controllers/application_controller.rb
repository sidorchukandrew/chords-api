class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  FORBIDDEN_MESSAGE = 'You do not have adequate permissions to perform this action'.freeze
  VIEW_SONGS = 'View songs'.freeze
  EDIT_SONGS = 'Edit songs'.freeze
  DELETE_SONGS = 'Delete songs'.freeze
  ADD_SONGS = 'Add songs'.freeze

  VIEW_BINDERS = 'View binders'.freeze
  EDIT_BINDERS = 'Edit binders'.freeze
  DELETE_BINDERS = 'Delete binders'.freeze
  ADD_BINDERS = 'Add binders'.freeze

  VIEW_SETLISTS = 'View sets'.freeze
  EDIT_SETLISTS = 'Edit sets'.freeze
  DELETE_SETLISTS = 'Delete sets'.freeze
  ADD_SETLISTS = 'Add sets'.freeze
  START_SESSIONS = 'Start sessions'.freeze
  PUBLISH_SETLISTS = 'Publish sets'.freeze

  EDIT_TEAM = 'Edit team'.freeze
  DELETE_TEAM = 'Delete team'.freeze

  ADD_MEMBERS = 'Add members'.freeze
  REMOVE_MEMBERS = 'Remove members'.freeze

  VIEW_ROLES = 'View roles'.freeze
  ADD_ROLES = 'Add roles'.freeze
  EDIT_ROLES = 'Edit roles'.freeze
  DELETE_ROLES = 'Delete roles'.freeze
  ASSIGN_ROLES = 'Assign roles'.freeze

  VIEW_EVENTS = 'View events'.freeze
  ADD_EVENTS = 'Add events'.freeze
  EDIT_EVENTS = 'Edit events'.freeze
  DELETE_EVENTS = 'Delete events'.freeze

  VIEW_FILES = 'View files'.freeze
  ADD_FILES = 'Add files'.freeze
  EDIT_FILES = 'Edit files'.freeze
  DELETE_FILES = 'Delete files'.freeze

  MANAGE_BILLING = 'Manage billing'.freeze

  private

  def authenticate_team
    set_current_user

    if @current_user.belongs_to_team?(params[:team_id])
      @current_member = @current_user.memberships.find_by(team_id: params[:team_id])
      @current_subscription = Subscription.find_by(team_id: params[:team_id])
    else
      return render json: { errors: ['You do not have access to this team\'s resources'] }, status: :forbidden
    end
  end

  def set_current_user
    @current_user = User.find(current_user.id)
  end

  def name_passed?
    params.key?(:name)
  end

  def authenticate_admin
    return render status: :forbidden unless @current_user.is_admin
  end

  def return_forbidden
    return render json: FORBIDDEN_MESSAGE, status: :forbidden
  end
end
