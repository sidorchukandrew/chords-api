json.(@role, :name, :description, :created_at, :updated_at, :is_admin, :is_member, :permissions)

json.memberships @role.memberships do |member|
  json.(member, :position, :id, :created_at, :updated_at)
  json.(member.user, :email, :first_name, :last_name, :phone_number, :timezone)
  json.user_id member.user.id
  json.image_url member.user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url
end