class ContactSubmissionsController < ApplicationController
  
  def create
    ContactSubmissionsMailer.with(submission: submission).contact_submitted.deliver_now
  end

  private

  def submission
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      message: params[:message]
    }
  end
end
