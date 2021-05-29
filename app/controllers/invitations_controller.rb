class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:claim, :signup_through_invitation]
  before_action :authenticate_team, except: [:claim, :signup_through_invitation]
  before_action :set_invitation, only: [:show, :update, :destroy, :resend]

  # GET /invitations
  def index
    @invitations = Invitation.where(team_id: params[:team_id])

    render json: @invitations
  end

  # GET /invitations/1
  def show
    render json: @invitation
  end

  # POST /invitations/1/resend
  def resend
    InvitationMailer.with(invitation: @invitation, sender: @current_user).invite_member.deliver_now
    render json: @invitation
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = @current_user

    if @invitation.save
      InvitationMailer.with(invitation: @invitation, sender: @current_user).invite_member.deliver_now
      render json: @invitation, status: :created, location: @invitation
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  # POST /invitations/claim
  def claim
    begin
      @invitation = Invitation.find_by_token!(params[:token])
      @invited_user = User.find_by_email(@invitation.email)

      if @invited_user
        @invited_user.join_team(@invitation.team_id)
        complete_claim(@invited_user)
      else
        render json: {message: "You need to sign up for an account first"}, status: 400
      end

    rescue ActiveRecord::RecordNotFound
      render json: {message: "This invitation is not valid"}, status: :not_found
    end
  end

  # PATCH/PUT /invitations/1
  def update
    if @invitation.update(invitation_params)
      render json: @invitation
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invitations/1
  def destroy
    @invitation.destroy
  end

  # POST /invitations/signup
  def signup_through_invitation
    begin
      @invitation = Invitation.find_by_token!(params[:token])

      if User.exists?(email: @invitation.email)
        render json: {message: "You've already signed up for an account"}, status: :bad_request
      else
        @new_user = User.new(email: @invitation.email, password: params[:password], 
          password_confirmation: params[:password_confirmation], confirmed_at: Time.now)

          if @new_user.save
            @new_user.join_team(@invitation.team_id)
            complete_claim(@new_user)
          else
            render json: {message: @new_user.errors.full_messages}, status: :bad_request
          end
      end
    rescue ActiveRecord::RecordNotFound
      render json: {message: "This invitation is not valid"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      invitation_id = params[:id] ? params[:id] : params[:invitation_id]
      @invitation = Invitation.where(id: invitation_id, team_id: params[:team_id]).first
    end

    # Only allow a list of trusted parameters through.
    def invitation_params
      params.require(:invitation).permit([:email, :team_id])
    end

    def complete_claim(user)
      team_id = @invitation.team_id
      @invitation.delete

      new_auth_header = user.create_new_auth_token

      if new_auth_header["uid"] == ""
        new_auth_header["uid"] = user.email
      end
      
      response.headers.merge!(new_auth_header)

      render json: {team_id: team_id}
    end
end
