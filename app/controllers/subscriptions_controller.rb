class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subscriptions = Subscription.includes(:team).where(user: @current_user)
    render json: @subscriptions, include: [:team]
  end

  def show
  end

end
