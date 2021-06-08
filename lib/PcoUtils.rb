module PcoUtils
    OAUTH_APP_ID = ENV['PLANNING_CENTER_APP_ID']
    OAUTH_SECRET = ENV['PLANNING_CENTER_APP_SECRET']
    SCOPE = 'services'
    API_URL = 'https://api.planningcenteronline.com'

    def refresh_token_params(refresh_token)
        {
            "client_id" => OAUTH_APP_ID, 
            "client_secret" => OAUTH_SECRET, 
            "refresh_token" => refresh_token, 
            "grant_type" => "refresh_token"
        }
    end
end