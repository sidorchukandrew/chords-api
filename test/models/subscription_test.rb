require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase

  test "should return billing managers" do
    pro_subscription = subscriptions(:pro_subscription)

    billing_managers = pro_subscription.billing_managers
    
    andrew = users(:andrew)
    dan = users(:dan_billing_manager)

    is_andrew_in_list = billing_managers.find { |manager| manager.id == andrew.id }
    is_dan_in_list = billing_managers.find { |manager| manager.id == dan.id }

    assert_equal 2, billing_managers.length

    assert is_andrew_in_list
    assert is_dan_in_list
  end
    
end