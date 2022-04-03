module AppleMusic

    class Config
        ALGORITHM = 'ES256'

        attr_accessor :private_key, :team_id, :key_id, :token_expiration_time

        def initialize
            @private_key = ENV['APPLE_MUSIC_PRIVATE_KEY']
            @team_id = ENV['APPLE_MUSIC_TEAM_ID']
            @key_id = ENV['APPLE_MUSIC_KEY_ID']
            @token_expiration_time = 6.days.to_i
        end

        def authentication_token
            private_key = OpenSSL::PKey::EC.new(@private_key)
            JWT.encode(authentication_payload, private_key, ALGORITHM, kid: @key_id)
        end

        private

        def authentication_payload(now = Time.now)
            {
                iss: @team_id,
                iat: now.to_i,
                exp: now.to_i + @token_expiration_time
            }
        end
    end


    class << self

        API_URI = 'https://api.music.apple.com/v1/'

        def config
            @config ||= Config.new
        end

        def configure(&block)
            block.call(config)
        end

        def search(**params)
            params[:types] ||= 'songs'
            params[:limit] = 25
            begin
                response = RestClient.get("#{API_URI}/catalog/us/search", headers.merge({params: params}))
                HashWithIndifferentAccess.new(JSON.parse(response.body))
            rescue RestClient::ExceptionWithResponse => e
                e.response
            end
        end

        private 

        def headers
            {
                "Authorization" => "Bearer #{config.authentication_token}"
            }
        end
    end
end