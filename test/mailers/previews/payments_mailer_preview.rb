# Preview all emails at http://localhost:3000/rails/mailers/payments_mailer
class PaymentsMailerPreview < ActionMailer::Preview
      def no_payment_method
        user = User.first

        PaymentsMailer.with(user: user).no_payment_method
    end
end
