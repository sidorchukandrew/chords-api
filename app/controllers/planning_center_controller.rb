require 'oauth2'

class PlanningCenterController < ApplicationController
    before_action :authenticate_user!

    OAUTH_APP_ID = ENV['PLANNING_CENTER_APP_ID']
    OAUTH_SECRET = ENV['PLANNING_CENTER_APP_SECRET']
    SCOPE = 'services'
    API_URL = 'https://api.planningcenteronline.com'

    def auth
        if params[:code]
            token = client.auth_code.get_token(params[:code], redirect_uri: "http://localhost:3000/app/import/pco_redirect")
            @current_user.add_pco_token(token)
        end
    end

    private
    
    def client
        OAuth2::Client.new(OAUTH_APP_ID, OAUTH_SECRET, site: API_URL)
    end
end
