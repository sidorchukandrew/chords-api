# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :invitations
  has_many :memberships
  has_many :teams, through: :memberships

  def belongs_to_team?(team_id)
    self.teams.exists?(team_id)
  end

  def join_team(team)
    if team.class == Integer
      self.memberships.find_or_create_by(team_id: team)
    else
      self.teams << team
    end
  end
end
