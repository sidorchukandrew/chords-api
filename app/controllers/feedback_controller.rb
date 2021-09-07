class FeedbackController < ApplicationController
    before_action :authenticate_user!, :authenticate_team

    def create
        @team = Team.find(params[:team_id])

        FeedbackMailer.with(user: @current_user, team: @team, feedback: params[:text])
            .feedback_submitted
            .deliver_later
    end
end
