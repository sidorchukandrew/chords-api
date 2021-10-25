# Preview all emails at http://localhost:3000/rails/mailers/contact_submissions_mailer
class ContactSubmissionsMailerPreview < ActionMailer::Preview

  def contact_submitted
    submission = {
      first_name: 'John',
      last_name: 'Smith',
      email: 'johnsmith@gmail.com',
      message: 'Testing the contact form'
    }
    ContactSubmissionsMailer.with(submission: submission).contact_submitted
  end

end
