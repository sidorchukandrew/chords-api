json.(@membership, :position, :user_id, :id, :created_at, :updated_at)
json.(@membership.user,  :email, :first_name, :last_name, :phone_number, :timezone)
json.image_url @membership.user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url

json.role @membership.role

json.team @membership.team