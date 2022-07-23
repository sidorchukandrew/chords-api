class AdminMembershipsController < ApplicationController
  before_action :authenticate_user!, :authenticate_admin, :set_default_response_format
  
  def show
    @membership = Membership.includes(:user, :role, :team).find(params[:id])
  end

  private
  def set_default_response_format
    request.format = :json
  end
end
