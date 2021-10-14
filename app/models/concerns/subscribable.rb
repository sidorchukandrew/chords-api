module Subscribable
  extend ActiveSupport::Concern

  def subscribe(billing_user, plan)
    stripe_subscription = subscribe_in_stripe(billing_user, plan)

    subscription = Subscription.new do |s|
      s.user = billing_user
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
    stripe_subscription_id = subscription.stripe_subscription_id
    Stripe::Subscription.delete(stripe_subscription_id)
    puts 'Cancelling subscription in Stripe'
  end

  private

  def subscribe_in_stripe(billing_user, plan)
    if plan == 'Pro'
      subscribe_to_pro(billing_user)
    else
      subscribe_to_starter(billing_user)
    end
  end

  def subscribe_to_pro(billing_user)
    Stripe::Subscription.create({
      customer: billing_user.customer_id,
      items: [{ price: ENV['PRO_PLAN_PRICE_ID'] }],
      trial_period_days: 30,
      metadata: {
        team_id: id,
        team_name: name,
        billing_user_email: billing_user.email,
        billing_user_id: billing_user.id
      }
    })
  end

  def subscribe_to_starter(billing_user)
    Stripe::Subscription.create({
      customer: billing_user.customer_id,
      items: [{ price: ENV['STARTER_PLAN_PRICE_ID'] }],
      metadata: {
        team_id: id,
        team_name: name,
        billing_user_email: billing_user.email,
        billing_user_id: billing_user.id
      }
    })
  end

  def plan_name(plan)
    plan == 'Pro' ? 'Pro' : 'Starter'
  end
end