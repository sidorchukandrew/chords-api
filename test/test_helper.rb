ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def sign_in_as(user, password = 'password')
    post '/auth/sign_in', params: { email: user.email, password: password }    
  end

  def credentials
    client = @response.headers['client']
    token = @response.headers['access-token']
    uid = @response.headers['uid']

    creds = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
    }

    creds
  end

  def andrew
    users(:andrew)
  end

  def bob
    users(:bob)
  end
end
