require 'test_helper'
require 'stripe'

class StripeWebhooksControllerTest < ActionDispatch::IntegrationTest

  test "it should email all billing managers of expiring trial when no payment methods on team" do
    assert_emails 2 do
      webhook_event = {
        type: "customer.subscription.trial_will_end",
        data: {
          object: {
            id: "test"
          }
        }
      }

      post "/stripe/webhooks/trial_will_end", params: webhook_event
    end
  end

  test "it should not send email for expiring trial if payment method on team" do
    assert_emails 0 do

      # - - - - - - - - -  begin setup  - - - - - - - - -
      sign_in_as andrew
      team = { team: { name: "Webhooks Test", plan: "Pro"}, name: "Webhooks Test", plan: "Pro" }
      post "/teams", params: team, headers: credentials
      assert_response :success
      team = JSON.parse(@response.body)

      card = Stripe::PaymentMethod.create({
        type: 'card',
        card: {
          number: '4242424242424242',
          exp_month: 7,
          exp_year: 2023,
          cvc: '314',
        },
      })

      Stripe::PaymentMethod.attach(
        card["id"],
        {customer: team["customer_id"]}
      )
      # - - - - - - - - -  end setup  - - - - - - - - -

      webhook_event = {
        type: "customer.subscription.trial_will_end",
        data: {
          object: {
            id: team["subscription"]["stripe_subscription_id"]
          }
        }
      }

      post "/stripe/webhooks/trial_will_end", params: webhook_event

      # cleanup
      Stripe::Customer.delete(team["customer_id"])
    end
  end

end