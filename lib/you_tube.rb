module YouTube

    class Config
        attr_accessor :access_token

        def initialize
            @access_token = ENV["YOUTUBE_ACCESS_TOKEN"]
        end
    end

    class << self
        API_URI = "https://youtube.googleapis.com/youtube/v3"

        def config
            @config ||= Config.new
        end

        def configure(&block)
            block.call(config)
        end

        def search(**params)
            params[:type] ||= 'video'
            params[:part] ||= 'snippet'
            params[:key] = config.access_token
            params[:maxResults] = 25

            begin
                response = RestClient.get("#{API_URI}/search", params: params)
                HashWithIndifferentAccess.new(JSON.parse(response.body))
            rescue RestClient::ExceptionWithResponse => e
                e.response
            end
        end
    end
end