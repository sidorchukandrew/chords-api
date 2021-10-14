class CustomerPortalSessionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @session = Stripe::BillingPortal::Session.create({
      customer: @current_user.customer_id,
      return_url: params[:return_url] || ENV['WEB_APP_BASE_URL']
    })

    render json: @session
  end
end
