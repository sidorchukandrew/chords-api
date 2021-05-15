class Song < ApplicationRecord
    has_and_belongs_to_many :binders

    has_and_belongs_to_many :genres
    has_and_belongs_to_many :themes

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
end
