class Song < ApplicationRecord
    has_and_belongs_to_many :binders
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :themes
    has_many :scheduled_songs
    has_many :setlists, through: :scheduled_songs

    belongs_to :team

    def remove_themes(theme_ids)
        if theme_ids && theme_ids.length > 0
            self.themes.delete(Theme.where(id: theme_ids))
        end
    end

    def add_themes(theme_ids)
        if theme_ids && theme_ids.length > 0
            self.themes.append(Theme.where(id: theme_ids))
        end
    end

    def remove_genres(genre_ids)
        if genre_ids && genre_ids.length > 0
            self.genres.delete(Genre.where(id: genre_ids))
        end
    end

    def add_genres(genre_ids)
        if genre_ids && genre_ids.length > 0
            self.genres.append(Genre.where(id: genre_ids))
        end
    end

    def import_onsong(zip_file)
        
    end
end
