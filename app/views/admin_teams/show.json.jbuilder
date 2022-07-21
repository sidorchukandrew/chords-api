json.(@team, :id, :name, :created_at, :updated_at)

json.image_url @team.image&.variant(resize_to_limit: [200, 200])&.processed&.url

json.memberships @team.memberships do |member|
  json.(member, :position, :id, :created_at, :updated_at)
  json.(member.user, :email, :first_name, :last_name, :phone_number, :timezone)
  json.user_id member.user.id
  json.image_url member.user.profile_picture&.variant(resize_to_limit: [200, 200])&.processed&.url
end

json.subscription do 
  json.(@team.subscription, :id, :plan_name, :stripe_product_id, :stripe_price_id, :stripe_subscription_id, :created_at, :updated_at, :status)
end