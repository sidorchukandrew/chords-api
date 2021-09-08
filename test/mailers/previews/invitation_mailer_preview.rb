# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview

    def invite_member
        invitation = Invitation.new(token: "ergj0394ut9344g845g094gb", email: "someemail@cadencechords.com")

        sender = User.find_by(is_admin: true)

        InvitationMailer.with(invitation: invitation, sender: sender).invite_member
    end

end
