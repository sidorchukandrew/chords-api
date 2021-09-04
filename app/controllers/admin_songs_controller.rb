class AdminSongsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin

    def index
        @songs = Song.all
    end
end
