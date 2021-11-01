class FilesController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_team, only: [:create_team_image, :attach_to_song, :index_song_files, :delete_song_file, :update_song_file]
  before_action :validate_subscription, only: [:index_song_files, :update_song_file, :attach_to_song, :delete_song_files]
  before_action :can_view_files, only: [:index_song_files]
  before_action :can_edit_files, only: [:update_song_file]
  before_action :can_add_files, only: [:attach_to_song]
  before_action :can_delete_files, only: [:delete_song_file]

  before_action :set_song, only: [:attach_to_song, :index_song_files, :delete_song_file, :update_song_file]

  def create_user_image
    @current_user.profile_picture = params[:image]
    @current_user.save
    render json: @current_user.profile_picture.variant(resize_to_limit: [200, 200]).processed.url
  end

  def delete_user_image
    @current_user&.profile_picture&.purge
  end

  def create_team_image
    @team = Team.find(params[:team_id])
    @team.image.attach(params[:image])
    render json: @team.image.variant(resize_to_limit: [200, 200]).processed.url
  end

  def delete_team_image
    @team = Team.find(params[:team_id])
    @team.image&.purge
  end

  def attach_to_song
    @song.files.attach(params[:files])
    render json: from_attachments(@song.files)
  end

  def index_song_files
    render json: from_attachments(@song.files)
  end

  def delete_song_file
    @song.files.where(id: params[:id]).purge
  end

  def update_song_file
    file = @song.files.find(params[:id])
    updated_filename = "#{params[:name]}#{file.filename.extension_with_delimiter}"
    file.update(filename: updated_filename)
  end

  private

  def set_song
    @song = Song.find_by(id: params[:song_id], team_id: params[:team_id])
  end

  def from_attachments(attachments)
    attachments.map do |attachment|
      {
        name: attachment.filename,
        id: attachment.id,
        created_at: attachment.created_at,
        url: attachment.url,
        size: attachment.byte_size
      }
    end
  end

  def can_view_files
    return_forbidden unless @current_member.can? VIEW_FILES
  end

  def can_edit_files
    return_forbidden unless @current_member.can? EDIT_FILES
  end

  def can_delete_files
    return_forbidden unless @current_member.can? DELETE_FILES
  end

  def can_add_files
    return_forbidden unless @current_member.can? ADD_FILES
  end

  def validate_subscription
    return_forbidden unless @current_subscription.files_enabled?
  end
end
