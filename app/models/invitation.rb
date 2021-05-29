class Invitation < ApplicationRecord
    require 'securerandom'

    belongs_to :team
    belongs_to :user
    before_create :set_token

    validates :user_id, :team_id, :email, presence: true

    private
    def set_token
        self.token = SecureRandom.uuid
    end
end
