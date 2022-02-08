class CacheController < ApplicationController
  before_action :authenticate_user!, :authenticate_team
  
  def index_songs
    @songs = Song.includes(:binders, :themes, :genres, :notes, :capos, format_configurations: [:format])
                 .where(team_id: params[:team_id])

    @songs.each do |song|
      song.capo = song.capos&.find { |capo| capo.membership_id == @current_member.id }
      song.roadmap = song.roadmap&.split('@')
      format_configuration = song.format_configurations.find { |fc| fc.song_id == song.id && fc.user_id == @current_user.id }
      format_configuration = song.format_configurations.find { |fc| fc.song_id == song.id } unless format_configuration.present?

      song.format = format_configuration&.format || default_format 
    end

    render json: @songs, include: [:binders, :themes, :genres, :notes], methods: [:capo, :format]
  end

  def index_setlists
    @setlists = Setlist.includes(:scheduled_songs).where(team_id: params[:team_id])
    
    render json: @setlists, include: :scheduled_songs
  end


  private

  def default_format
    {
      font: 'Roboto Mono',
      font_size: 18,
      bold_chords: false,
      italic_chords: false
    }
  end
  
end
