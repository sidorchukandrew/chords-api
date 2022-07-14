require 'test_helper'
require 'stripe'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should prevent toggling join link if not authorized" do
    sign_in_as bob

    updates = { team: { join_link_enabled: true }, join_link_enabled: true }
    pro_team_id = teams(:pro_team).id
    put "/teams/#{pro_team_id}", params: updates, headers: credentials

    assert_response :forbidden
  end

  test "should allow editing team details without add_members permission" do
    sign_in_as bob

    updates = { team: { name: "New team name" }, name: "New team name" }
    pro_team_id = teams(:pro_team).id
    put "/teams/#{pro_team_id}", params: updates, headers: credentials

    assert_response :success
  end
  

  test "should create customer in stripe when team created" do
    sign_in_as andrew

    team = { team: { name: "Pro Team Test", plan: "Pro"}, name: "Pro Team Test", plan: "Pro" }

    post "/teams", params: team, headers: credentials

    assert_response :success
    team = JSON.parse(@response.body)

    customer = Stripe::Customer.retrieve(team["customer_id"])

    assert_equal team["name"], customer["name"]
    assert_equal ENV["ENVIRONMENT"], customer["metadata"]["env"]
    
    subscription = team["subscription"]

    # throws exception if not found, acts as a check for subscription existence
    stripe_subscription = Stripe::Subscription.retrieve(subscription["stripe_subscription_id"])

    assert_equal stripe_subscription["customer"], team["customer_id"]

    # cleanup
    Stripe::Customer.delete(team["customer_id"])
  end
end