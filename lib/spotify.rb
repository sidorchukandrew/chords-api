module Spotify

    class Config
        attr_accessor :client_id, :client_secret, :access_token
        AUTH_URI = "https://accounts.spotify.com/api/token"

        def initialize
            @client_id = ENV["SPOTIFY_CLIENT_ID"]
            @client_secret = ENV["SPOTIFY_CLIENT_SECRET"]
            @access_token = access_token
        end

        def access_token
            generate_new_token if @access_token.nil? || @expiry_date.nil? || expired?               
            @access_token
        end

        private
        
        def generate_new_token
            grant_type = { grant_type: "client_credentials" }
            begin
                response = RestClient.post(AUTH_URI, grant_type, request_headers)
                response = HashWithIndifferentAccess.new(JSON.parse(response.body))
                @access_token = response[:access_token]
                @expiry_date = Time.now + 3500.seconds
            rescue RestClient::ExceptionWithResponse => e
                e.response
            end
        end

        def request_headers
            encoded = Base64.encode64("#{@client_id}:#{@client_secret}").gsub("\n", '')
            authorization = "Basic #{encoded}"

            {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": authorization
            }
        end

        def expired?
            Time.now > @expiry_date
        end
    end

    class << self
        API_URI = "https://api.spotify.com/v1"

        def config
            @config ||= Config.new
        end

        def configure(&block)
            block.call(config)
        end

        def search(**params)
            params[:type] ||= 'track'

            begin
                response = RestClient.get("#{API_URI}/search", headers.merge({params: params}))
                HashWithIndifferentAccess.new(JSON.parse(response.body))
            rescue RestClient::ExceptionWithResponse => e
                e.response
            end
        end

        private 

        def headers
            {
                "Authorization" => "Bearer #{config.access_token}"
            }
        end
    end
end