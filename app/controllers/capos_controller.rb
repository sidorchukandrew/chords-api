class CaposController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  before_action :set_song, only: [:create]
  before_action :set_capo, only: [:destroy, :update]

  def create
    capo = Capo.new do |c|
      c.membership = @current_member
      c.capo_key = params[:capo_key]
      c.song = @song
    end

    if capo.save
      render json: capo
    else
      render json: capo.errors.full_messages
    end
  end

  def update
    if @capo.update(capo_params)
      render json: @capo
    else
      render json: @capo.errors.full_messages
    end
  end

  def destroy
    @capo.destroy
  end

  private

  def set_song
    @song = Song.find_by!(team_id: params[:team_id], id: params[:song_id])
  end

  def set_capo
    @capo = Capo.find_by!(id: params[:id], song_id: params[:song_id], membership: @current_member)
  end

  def capo_params
    params.permit(:capo_key)
  end
end
