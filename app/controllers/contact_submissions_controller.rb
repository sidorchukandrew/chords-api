class ContactSubmissionsController < ApplicationController
  
  def create
    ContactSubmissionsMailer.with(submission).contact_submitted.deliver_later
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
