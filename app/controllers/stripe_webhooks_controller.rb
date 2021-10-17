require 'stripe'

class StripeWebhooksController < ApplicationController

  def trial_will_end
    event = nil

    begin
      event = Stripe::Event.construct_from(params.as_json)
    rescue JSON::ParserError
      return render status: 400
    end

    case event.type
    when 'customer.subscription.trial_will_end'
      user = User.find_by(customer_id: event.data.object.customer)
      unless user.payment_method_attached?
        PaymentsMailer.with(user: user).no_payment_method.deliver_later
      end
    else
      puts "Unhandled event type: #{event.type}"
    end
  end

  def subscription_updated
    event = nil

    begin
      event = Stripe::Event.construct_from(params.as_json)
    rescue JSON::ParserError
      return render status: 400
    end

    case event.type
    when 'customer.subscription.updated'
      subscription = Subscription.find_by(stripe_subscription_id: event.data.object.id)
      subscription.stripe_product_id = event.data.object.items.data[0].price.product
      subscription.stripe_price_id = event.data.object.items.data[0].price.id
      subscription.status = event.data.object.status
      subscription.plan_name = get_plan_name(event.data.object.items.data[0].price.id)
      subscription.save
      puts 'Updated subscription'
    else
      puts "Unhandled event type: #{event.type}"
    end
  end

  def subscription_cancelled
    event = nil

    begin
      event = Stripe::Event.construct_from(params.as_json)
    rescue JSON::ParserError
      return render status: 400
    end

    case event.type
    when 'customer.subscription.deleted'
      begin
        @team = Team.find(event.data.object.metadata.team_id)
        @billing_user = @team.subscription.user

        @team.subscription.destroy
        @team.subscribe(@billing_user, 'Starter')

        # TODO: NOTIFY CUSTOMER THAT THEY WERE SUCCESSFULLY DOWNGRADED
        # TODO: DELETE HIGHER SUBSCRIPTION FEATURES
        @team.events.destroy_all
      rescue ActiveRecord::RecordNotFound
        return
      end
    else
      puts "Unhandled event type: #{event.type}"
    end
  end

  private

  def get_plan_name(price_id)
    price_id == ENV['PRO_PLAN_PRICE_ID'] ? 'Pro' : 'Starter'
  end
end
