class GenresController < ApplicationController
    before_action :authenticate_user!
    def index
        @genres = Genre.all

        render json: @genres
    end
end
