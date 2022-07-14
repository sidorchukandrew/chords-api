module Subscribable
  extend ActiveSupport::Concern

  def subscribe(plan)
    stripe_subscription = subscribe_in_stripe(plan)

    subscription = Subscription.new do |s|
      s.team = self
      s.status = stripe_subscription.status
      s.stripe_product_id = stripe_subscription.items.data[0].price.product
      s.stripe_price_id = stripe_subscription.items.data[0].price.id
      s.stripe_subscription_id = stripe_subscription.id
      s.plan_name = plan_name(plan)
    end

    subscription.save
  end

  def cancel_subscription
    if subscription
      stripe_subscription_id = subscription.stripe_subscription_id
      Stripe::Subscription.delete(stripe_subscription_id)
      puts 'Cancelling subscription in Stripe'
    end
  end

  private

  def subscribe_in_stripe(plan)
    if plan == 'Pro'
      subscribe_to_pro
    else
      subscribe_to_starter
    end
  end

  def subscribe_to_pro()
    Stripe::Subscription.create({
      customer: self.customer_id,
      items: [{ price: ENV['PRO_PLAN_PRICE_ID'] }],
      trial_period_days: 30,
      metadata: {
        "env": ENV["ENVIRONMENT"]
      }
    })
  end

  def subscribe_to_starter()
    Stripe::Subscription.create({
      customer: self.customer_id,
      items: [{ price: ENV['STARTER_PLAN_PRICE_ID'] }],
      metadata: {
        "env": ENV["ENVIRONMENT"]
      }
    })
  end

  def plan_name(plan)
    plan == 'Pro' ? 'Pro' : 'Starter'
  end
end