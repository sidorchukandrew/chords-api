class Song < ApplicationRecord
  include MusicUtils

  has_and_belongs_to_many :binders

  has_and_belongs_to_many :genres

  has_and_belongs_to_many :themes

  has_many :scheduled_songs, dependent: :destroy

  has_many :setlists, through: :scheduled_songs

  has_many :format_configurations, dependent: :destroy

  has_many :formats, through: :format_configurations

  has_many :notes, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  belongs_to :team

  has_many :capos, dependent: :destroy

  before_save :add_key_if_not_present

  scope :without_content, -> { select(Song.column_names - ['content']) }

  def remove_themes(theme_ids)
    themes.delete(Theme.where(id: theme_ids)) if theme_ids && !theme_ids.empty?
  end

  def add_themes(theme_ids)
    themes.append(Theme.where(id: theme_ids)) if theme_ids && !theme_ids.empty?
  end

  def remove_genres(genre_ids)
    genres.delete(Genre.where(id: genre_ids)) if genre_ids && !genre_ids.empty?
  end

  def add_genres(genre_ids)
    genres.append(Genre.where(id: genre_ids)) if genre_ids && !genre_ids.empty?
  end

  private

  def add_key_if_not_present
    self.original_key = detect_key(content) if content && !original_key
  end
end
