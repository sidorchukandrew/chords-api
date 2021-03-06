json.(@team, :id, :name, :created_at, :updated_at, :join_link, :join_link_enabled, :customer_id)

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

json.roles @team.roles do |role|
  json.(role, :name, :description, :id, :created_at, :updated_at, :is_admin, :is_member)
end