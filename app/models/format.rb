class Format < ApplicationRecord
    has_many :format_configurations
    has_many :songs, through: :format_configurations

    scope :for_song_and_user, ->(song, user) { joins(:format_configurations)
                                    .where("format_configurations.song_id = ? ", song.id)
                                    .where("format_configurations.user_id = ? ", user.id) 
                                }

    scope :for_song, ->(song_id) { joins(:format_configurations)
                                    .where("format_configurations.song_id = ? ", song_id)                            
                                }

    scope :for_user, ->(user_id) { joins(:format_configurations)
                                    .where("format_configurations.user_id = ? ", user_id)                            
                                }
    scope :for_team, ->(team_id) { joins(:format_configurations)
                                    .where("format_configurations.team_id = ? ", team_id)                            
                                }
end
