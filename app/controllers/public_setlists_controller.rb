class PublicSetlistsController < ApplicationController

    def index
        @setlists = PublicSetlist.where("? < expires_on", Time.current.utc)

        render json: @setlists
    end

    def show
        begin
            identifierQuery = {}

            @setlist = PublicSetlist.where("? < expires_on", Time.current.utc)
                            .where(id_query)
                            .first

            render json: @setlist.to_hash
        rescue
            render status: 404
        end
    end

    def create
        if does_not_exist?
            @public_setlist = PublicSetlist.new do |public_setlist|
                public_setlist.code = SecureRandom.uuid
                public_setlist.expires_on = Time.now + 24.hours
                public_setlist.setlist_id = params[:setlist_id]
            end
            
            if @public_setlist.save
                render json: @public_setlist.to_hash
            else
                render json: @public_setlist.errors
            end
        else
            render json: {errors: ["This setlist is already published"]}, status: :bad_request
        end
    end

    def update
        @public_setlist = PublicSetlist.find_by(code: params[:id])

        if @public_setlist.present?
            if @public_setlist.update(public_setlist_params)
                render json: @public_setlist
            else   
                render @public_setlist.errors, status: :bad_request
            end
        else
            render status: 404
        end
    end

    private
    def public_setlist_params
        params.permit(:setlist_id, :expires_on)
    end

    def does_not_exist?
        PublicSetlist.where(setlist_id: params[:setlist_id]).where("expires_on > ?", Time.now).count == 0
    end

    def id_query
        query = {}
        begin
            Integer(params[:id])
            query = {setlist_id: params[:id]}
        rescue
           query = {code: params[:id]}
        end

        query
    end
end
