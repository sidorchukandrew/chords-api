class ContactSubmissionsController < ApplicationController
  
  def create
    ContactSubmissionsMailer.with(submission_params).contact_submitted.deliver_later
  end

  private
  def submission_params
    params.permit(:first_name, :last_name, :email, :message)
  end
end
