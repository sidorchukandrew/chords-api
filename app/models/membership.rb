class Membership < ApplicationRecord
  belongs_to :team
  belongs_to :user
  belongs_to :role

  def to_hash
    membership = as_json
    membership[:id] = user.id
    membership[:email] = user.email
    membership[:first_name] = user.first_name
    membership[:last_name] = user.last_name
    membership[:image_url] = user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url
    
    membership.as_json
  end

  def can?(permission)
    puts "Checking if has permission #{permission}"
    role.present? && role.permissions.where(name: permission).exists?
  end
end


