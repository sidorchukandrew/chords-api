class AppleMusicController < ApplicationController
    before_action :authenticate_user!

    def search
        render json: AppleMusic.search(term: params[:query])
    end
end
