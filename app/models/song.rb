class Song < ApplicationRecord
  has_and_belongs_to_many :binders

  has_and_belongs_to_many :genres

  has_and_belongs_to_many :themes

  has_many :scheduled_songs, dependent: :destroy

  has_many :setlists, through: :scheduled_songs

  has_many :format_configurations, dependent: :destroy

  has_many :formats, through: :format_configurations

  belongs_to :team

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

  def import_onsong(zip_file); end
end
