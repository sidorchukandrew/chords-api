class Membership < ApplicationRecord
    belongs_to :team
    belongs_to :user

    def to_hash
        membership = self.as_json
        membership[:id] = self.user.id
        membership[:email] = self.user.email
        membership[:first_name] = self.user.first_name
        membership[:last_name] = self.user.last_name
        membership[:image_url] = self.user.profile_picture.url
        
        membership.as_json
    end
end
