class InvitationMailer < ApplicationMailer

    def invite_member
        @invitation = params[:invitation]
        @sender = params[:sender]
        @sender_full_name = "Someone"

        if @sender.first_name
            @sender_full_name = "#{@sender.first_name} #{@sender.last_name}"
        end

        @claim_token_url = "#{ENV["WEB_APP_BASE_URL"]}/invitations?token=#{@invitation.token}"

        mail(to: @invitation.email, subject: "#{@sender_full_name} has sent you an invitation")
    end
end
