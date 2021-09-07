class FeedbackMailer < ApplicationMailer

    def feedback_submitted
        @user = params[:user]
        @team = params[:team]
        @feedback = params[:feedback]

        mail(to: ENV["FEEDBACK_RECEIVER_EMAIL"], subject: "Feedback submitted by #{@user.email}")
    end

end
