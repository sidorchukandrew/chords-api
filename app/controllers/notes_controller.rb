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
      notify_via_telegram
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
    params.permit(:color, :line_number, :content, :team_id, :song_id, :x, :y)
  end

  def validate_subscription
    return_forbidden unless @current_subscription.notes_enabled?
  end

  def notify_via_telegram
    if params[:team_id] == 5 || params[:team_id] == '5'
      message = "
        Member: #{@current_member.user.email}
        Note: {
          id: #{@note.id},
          color: #{@note.color},
          song:  #{@note.song.name},
          x: #{@note.x},
          y: #{@note.y}
        }
      "
      Telegram.send_message(message)
    end
  end
end
