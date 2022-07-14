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
      subscription = Subscription.find_by_stripe_subscription_id(event.data.object.id)
      billing_managers = subscription.billing_managers

      unless subscription.team.payment_method_attached?
        billing_managers.each do |manager|
          PaymentsMailer.with(user: manager).no_payment_method.deliver_later
        end
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

        puts 'Checking if subscription in cancel request matches current subscription on team'
        puts "Cancel subscription: #{event.data.object.id}, Team subscription: #{@team.subscription.stripe_subscription_id}"
        return unless @team.subscription.stripe_subscription_id == event.data.object.id

        @team.subscription.destroy

        puts 'Creating new starter subscription because previous subscription was destroyed'
        @team.subscribe('Starter')

        # TODO: NOTIFY CUSTOMER THAT THEY WERE SUCCESSFULLY DOWNGRADED
        # TODO: DELETE HIGHER SUBSCRIPTION FEATURES
        # @team.events.destroy_all
        # @team.songs.each do |s|
        #   s.files.purge_later
        # end
        # @team.notes.destroy_all
        # @team.tracks.destroy_all

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
