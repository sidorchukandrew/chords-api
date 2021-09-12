class PermissionsController < ApplicationController
  def index
    render json: Permission.all
  end

  def show
    render json: Permission.find(params[:id])
  end
end
