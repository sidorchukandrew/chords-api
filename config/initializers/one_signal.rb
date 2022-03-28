require 'onesignal'

OneSignal.configure do |config|
  config.user_key = ENV['ONE_SIGNAL_AUTH_KEY']
  config.app_key = ENV['ONE_SIGNAL_REST_API_KEY']
end