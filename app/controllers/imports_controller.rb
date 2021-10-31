class ImportsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team, :can_add_songs?

  def import
    importer = SongFileImporter.new(params[:files], params[:team_id])
    importer.convert_files

    render json: importer.errors, status: :unprocessable_entity if importer.errors?
  end

  private

  def can_add_songs?
    return_forbidden unless @current_member.can? ADD_SONGS
  end
end
