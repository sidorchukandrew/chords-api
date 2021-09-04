class AdminSongsController < ApplicationController
    before_action authenticate_user!, authenticate_admin

    def index
        @songs = Song.all
    end
end
