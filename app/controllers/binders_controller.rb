class BindersController < ApplicationController
  
  before_action :authenticate_user!, :authenticate_team
  before_action :can_add_binders, only: [:create]
  before_action :can_edit_binders, only: [:update, :add_songs, :remove_songs]
  before_action :can_view_binders, only: [:index, :show]
  before_action :can_delete_binders, only: [:destroy]
  before_action :set_binder, only: [:show, :update, :destroy, :add_songs, :remove_songs]

  # GET /binders
  def index
    @binders = Binder.includes(:songs).where(team_id: params[:team_id])
    @binders = @binders.where('name ILIKE ?', "%#{params[:name]}%") if name_passed?

    render json: @binders if name_passed?
    render json: @binders, include: :songs unless name_passed?
  end

  # GET /binders/1
  def show
    render json: @binder, include: :songs
  end

  # POST /binders
  def create
    @binder = Binder.new(binder_params)

    if @binder.save
      render json: @binder, status: :created, location: @binder
    else
      render json: @binder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /binders/1
  def update
    if @binder.update(binder_params)
      render json: @binder, include: :songs
    else
      render json: @binder.errors, status: :unprocessable_entity
    end
  end

  def add_songs
    @binder.add_songs(params[:song_ids])

    render json: @binder.songs.where(id: params[:song_ids])
  end

  def remove_songs
    @binder.remove_songs(params[:song_ids])
  end

  # DELETE /binders/1
  def destroy
    @binder.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_binder
    if params[:id]
      @binder = Binder.where(id: params[:id], team_id: params[:team_id]).first
    elsif params[:binder_id]
      @binder = Binder.where(id: params[:binder_id], team_id: params[:team_id]).first
    end
  end

  # Only allow a list of trusted parameters through.
  def binder_params
    params.permit([:name, :description, :color, :team_id, :song_ids])
  end

  def can_view_binders
    return_forbidden unless @current_member.can? VIEW_BINDERS
  end

  def can_edit_binders
    return_forbidden unless @current_member.can? EDIT_BINDERS
  end

  def can_delete_binders
    return_forbidden unless @current_member.can? DELETE_BINDERS
  end

  def can_add_binders
    return_forbidden unless @current_member.can? ADD_BINDERS
  end
end
