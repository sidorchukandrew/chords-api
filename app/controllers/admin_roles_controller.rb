class AdminRolesController < ApplicationController
  before_action :authenticate_user!, :authenticate_admin, :set_default_response_format

  def show
    @role = Role.includes(:permissions, memberships: [:user]).find(params[:id])
  end

  private
  def set_default_response_format
    request.format = :json
  end
end
