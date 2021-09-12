class FeedbackController < ApplicationController
  require 'trello'

  before_action :authenticate_user!, :authenticate_team
  before_action :configure_trello, only: [:create]

  def create
    @team = Team.find(params[:team_id])

    Trello::Card.create(card_params)

    FeedbackMailer.with(user: @current_user, team: @team, feedback: params[:text])
                  .feedback_submitted
                  .deliver_later
  end

  private

  def configure_trello
    Trello.configure do |c|
      c.developer_public_key = ENV['TRELLO_PUBLIC_KEY']
      c.member_token = ENV['TRELLO_TOKEN']
    end
  end

  def card_params
    {
      list_id: ENV['TRELLO_LIST_ID'],
      name: params[:text],
      desc: card_description
    }
  end

  def card_description
    "**Submitter**\n" +
    "Email: #{@current_user.email}\n" +
    "Name: #{@current_user.first_name} #{@current_user.last_name}\n\n" +
    "**Team**\n" +
    "Name: #{@team.name}\n\n" +
    "**Time**\n" +
    "#{current_time}"
  end

  def current_time
    Time.current.in_time_zone('America/New_York').strftime('%a %b %e %Y %I:%M %p')
  end
end
