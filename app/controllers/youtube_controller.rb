class YoutubeController < ApplicationController
    before_action :authenticate_user!

    def search
        render json: YouTube.search(q: params[:query])
    end
end
