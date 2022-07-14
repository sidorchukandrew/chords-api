# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User
  include PcoUtils
  include Notifiable

  has_many :invitations, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_one_attached :profile_picture
  has_many :subscriptions
  has_many :notification_settings, dependent: :destroy
  has_many :sessions, dependent: :destroy
  
  after_create :add_notification_settings

  def belongs_to_team?(team_id)
    self.teams.exists?(team_id)
  end

  def join_team(team_id)
    memberships.find_or_create_by!(team_id: team_id) do |membership|
      membership.role = Role.find_or_create_by!(name: 'Member', team_id: team_id)
    end
  end

  def leave_team(team_id)
    memberships.find_by_team_id(team_id).destroy
  end

  def add_pco_token(token)
    self.pco_access_token = token.token
    self.pco_refresh_token = token.refresh_token
    self.pco_token_expires_at = Time.at(token.expires_at)
    save
  end

  def refresh_pco_token
    token_response = pco_api.oauth.token.post(refresh_token_params(pco_refresh_token))
    self.pco_access_token = token_response['access_token']
    self.pco_refresh_token = token_response['refresh_token']
    self.pco_token_expires_at = Time.at(Time.now + token_response['expires_in'].seconds)
    save
  end

  def to_hash
    user_hash = {
        id: id,
        uid: uid,
        email: email,
        created_at: created_at,
        first_name: first_name,
        last_name: last_name,
        image_url: profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url,
        pco_connected: pco_token_active?,
        phone_number: phone_number,
        timezone: timezone
    }

    user_hash
  end

  private

  def pco_token_active?
    fields_present = self.pco_access_token && self.pco_refresh_token && self.pco_token_expires_at

    if fields_present
      token_or_refresh_token_active = self.pco_token_expires_at + 90.days > Time.now
      return token_or_refresh_token_active
    else
      return false
    end
  end

  def pco_api
    PCO::API.new(oauth_access_token: self.pco_access_token, url: API_URL)
  end
end
