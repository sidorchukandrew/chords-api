class PublicSetlistsController < ApplicationController

    def index
        @setlists = PublicSetlist.where("? < expires_on", Time.now)

        render json: @setlists
    end

    def show
        begin
            @setlist = PublicSetlist.where("? < expires_on", Time.now).where(code: params[:id]).first
            render json: @setlist.to_hash
        rescue
            render status: 404
        end
    end

end
