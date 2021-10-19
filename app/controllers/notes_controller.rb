class NotesController < ApplicationController
  before_action :authenticate_user!, :authenticate_team, :validate_subscription
  before_action :set_note, only: [:show, :update, :destroy]

  # GET /notes
  def index
    @notes = Note.all

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)

    if @note.save
      render json: @note, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
  end

  private

  def set_note
    @note = Note.find_by(id: params[:id], team_id: params[:team_id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.permit(:color, :line_number, :content, :team_id, :song_id)
  end

  def validate_subscription
    return_forbidden unless @current_subscription.notes_enabled?
  end
end
