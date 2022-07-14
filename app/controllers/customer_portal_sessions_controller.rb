class CustomerPortalSessionsController < ApplicationController
  before_action :authenticate_user!, :authenticate_team, :can_manage_billing

  def create
    current_team = @current_subscription.team
    @session = Stripe::BillingPortal::Session.create({
      customer: current_team.customer_id,
      return_url: params[:return_url] || ENV['WEB_APP_BASE_URL']
    })

    render json: @session
  end

  private

  def can_manage_billing
    return_forbidden unless @current_member.can? MANAGE_BILLING
  end
end
