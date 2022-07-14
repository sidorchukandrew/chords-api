class PaymentsMailer < ApplicationMailer

  def no_payment_method
    user = params[:user]

    mail(to: user.email, subject: 'Trial ending soon, missing payment method')
  end

end
