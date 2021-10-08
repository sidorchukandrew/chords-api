module Billable
  extend ActiveSupport::Concern

  def payment_method_attached?
    payment_methods = Stripe::PaymentMethod.list({ customer: customer_id, type: 'card' })
    !payment_methods.data.empty?
  end

end