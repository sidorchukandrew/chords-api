module Telegram

    class << self
        
        API_URI = "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_ACCESS_TOKEN']}"

        def send_message(message)
            params = {
                chat_id: ENV['TELEGRAM_CHAT_ID'],
                text: message
            }

            begin
                response = RestClient.get("#{API_URI}/sendMessage", {params: params})
                HashWithIndifferentAccess.new(JSON.parse(response.body))
            rescue RestClient::ExceptionWithResponse => e
                e.response
            end
        end
    end
end