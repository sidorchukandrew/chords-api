class SpotifyController < ApplicationController
    before_action :authenticate_user!

    def search
        render json: Spotify.search(q: params[:query])
    end
end
