# Preview all emails at http://localhost:3000/rails/mailers/feedback_mailer
class FeedbackMailerPreview < ActionMailer::Preview

    def feedback_submitted
        user = User.find_by(is_admin: true)
        team = user.teams.first
        feedback = "This is a test email"

        FeedbackMailer.with(user: user, team: team, feedback: feedback).feedback_submitted
    end
end
