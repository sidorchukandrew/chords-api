json.(@user, :id, :uid, :email, :created_at, :updated_at, :first_name, :last_name, :phone_number, :timezone)

json.image_url @user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url

json.teams @user.teams.map { |team| team.to_hash }
json.notification_settings @user.notification_settings