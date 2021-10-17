class FormatsController < ApplicationController
    before_action :authenticate_user!, :authenticate_team
    before_action :set_format, except: %i[index create]

    def index
        user_id = params[:user_id]
        song_id = params[:song_id]

        formats = FormatConfiguration.custom_and_default_formats
    end

    def update
        if @format.update(format_params)
            render json: @format
        else
            render json: @format.errors, status: :unprocessable_entity
        end
    end

    def create
        @format = Format.new(format_params)

        if @format.save
            @format_config = FormatConfiguration.new(format_config_params)

            if @format_config.save
                render json: @format
            else
                render json: @format_config.errors, status: :unprocessable_entity
            end
        else
            render json: @format.errors, status: :unprocessable_entity
        end
    end

    private
    def format_params
        params.permit(:font_size, :font, :bold_chords, :italic_chords)
    end

    def set_format
      @format = Format.find(params[:id])
    end

    def format_config_params
        config = {
            song_id: params[:song_id],
            team_id: params[:team_id],
            user_id: @current_user.id,
            format_id: @format.id
        }
    end

end
