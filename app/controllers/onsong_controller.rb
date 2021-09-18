class OnsongController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  before_action :can_add_songs?, only: [:unzip, :import]
  before_action :set_import, only: [:import]
  before_action :authenticate_binder, only: [:import]

  def unzip
    @import = OnsongImport.new(import_params)
    @files = @import.unzip(params[:backup])
    @import.backup.attach(params[:backup])
    puts 'Attached!'
    @import.save

    render json: @files
  end

  def import
    @import.create_songs(params[:songs], params[:binder_id])
    render json: { errors: @import.custom_errors }, status: :unprocessable_entity if @import.custom_errors.present?
  end

  private

  def set_import
    @import = OnsongImport.find_by(team_id: params[:team_id])
  end

  def can_add_songs?
    return_forbidden unless @current_member.can? ADD_SONGS
  end

  def import_params
    params.permit([:team_id])
  end

  def authenticate_binder
    if params[:binder_id]
      begin
        @import.team.binders.find(params[:binder_id])
      rescue RecordNotFound
        return render json: FORBIDDEN_MESSAGE, status: :forbidden
      end
    end
  end
end
