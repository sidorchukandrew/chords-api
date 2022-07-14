require 'test_helper'
require 'stripe'

class CustomerPortalSessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @generated_customer_ids = []
  end

  def teardown
    @generated_customer_ids.each do |customer_id|
      puts "Deleting #{customer_id} customer"
      Stripe::Customer.delete(customer_id)
    end
  end

  test "should return a customer portal session if authorized" do
    sign_in_as andrew
    team = {name: "Pro Team [Test]", plan: "Pro", team: {name: "Pro Team [Test]", plan: "Pro"}}

    post "/teams", params: team, headers: credentials

    assert_response :success
    team = JSON.parse(@response.body)

    portal_session = {return_url: "http://localhost:3000"}

    post "/billing/customer_portal_sessions?team_id=#{team['id']}", params: portal_session, headers: credentials
    assert_response :success

    portal_session = JSON.parse(@response.body)

    assert_equal portal_session["return_url"], "http://localhost:3000"

    # cleanup
    @generated_customer_ids << team["customer_id"]
  end
end