# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Genre.find_or_create_by!(name: "Rock")
Genre.find_or_create_by!(name: "Country")
Genre.find_or_create_by!(name: "Contemporary")
Genre.find_or_create_by!(name: "Progressive")
Genre.find_or_create_by!(name: "Reggae")
Genre.find_or_create_by!(name: "Spoken Word")
Genre.find_or_create_by!(name: "Alternative")
Genre.find_or_create_by!(name: "Blues")
Genre.find_or_create_by!(name: "Classical")
Genre.find_or_create_by!(name: "Dance")
Genre.find_or_create_by!(name: "Disney")
Genre.find_or_create_by!(name: "Electronic")
Genre.find_or_create_by!(name: "Hip Hop")
Genre.find_or_create_by!(name: "Rap")
Genre.find_or_create_by!(name: "Indie")
Genre.find_or_create_by!(name: "Industrial")
Genre.find_or_create_by!(name: "Christian")
Genre.find_or_create_by!(name: "Gospel")
Genre.find_or_create_by!(name: "Instrumental")
Genre.find_or_create_by!(name: "Jazz")
Genre.find_or_create_by!(name: "K-Pop")
Genre.find_or_create_by!(name: "Karoake")
Genre.find_or_create_by!(name: "Latin")
Genre.find_or_create_by!(name: "Latin")
Genre.find_or_create_by!(name: "Opera")
Genre.find_or_create_by!(name: "World")  

Permission.find_or_create_by!(name: "View songs") do |permission|
    permission.description = "Allow user to view all songs"
end

Permission.find_or_create_by!(name: "Edit songs") do |permission|
    permission.description = "Allow user to edit any songs"
end

Permission.find_or_create_by!(name: "Delete songs") do |permission|
    permission.description = "Allow user to delete any songs"
end

Permission.find_or_create_by!(name: "Add songs") do |permission|
    permission.description = "Allow user to create or import songs"
end



Permission.find_or_create_by!(name: "View binders") do |permission|
    permission.description = "Allow user to view all binders"
end

Permission.find_or_create_by!(name: "Edit binders") do |permission|
    permission.description = "Allow user to edit any binders"
end

Permission.find_or_create_by!(name: "Delete binders") do |permission|
    permission.description = "Allow user to delete any binders"
end

Permission.find_or_create_by!(name: "Add binders") do |permission|
    permission.description = "Allow user to create binders"
end



Permission.find_or_create_by!(name: "View sets") do |permission|
    permission.description = "Allow user to view all sets"
end

Permission.find_or_create_by!(name: "Edit sets") do |permission|
    permission.description = "Allow user to edit any sets"
end

Permission.find_or_create_by!(name: "Delete sets") do |permission|
    permission.description = "Allow user to delete any sets"
end

Permission.find_or_create_by!(name: "Add sets") do |permission|
    permission.description = "Allow user to create sets"
end

Permission.find_or_create_by!(name: "Publish sets") do |permission|
    permission.description = "Allow user to publish sets"
end

Permission.find_or_create_by!(name: "Edit team") do |permission|
    permission.description = "Allow user to edit team information like name and profile picture"
end

Permission.find_or_create_by!(name: "Delete team") do |permission|
    permission.description = "Allow user to delete team"
end

Permission.find_or_create_by!(name: "Add members") do |permission|
    permission.description = "Allow user to add members to the team and resend or cancel invitations"
end

Permission.find_or_create_by!(name: "Remove members") do |permission|
    permission.description = "Allow user to remove members from the team"
end

Permission.find_or_create_by!(name: "View roles") do |permission|
    permission.description = "Allow user to view the role configuration page"
end

Permission.find_or_create_by!(name: "Add roles") do |permission|
    permission.description = "Allow user to create new roles in the team"
end

Permission.find_or_create_by!(name: "Delete roles") do |permission|
    permission.description = "Allow user to delete roles in the team"
end

Permission.find_or_create_by!(name: "Edit roles") do |permission|
    permission.description = "Allow user to edit roles, such as adding and removing permissions to the role"
end

Permission.find_or_create_by!(name: "Assign roles") do |permission|
    permission.description = "Allow user to assign roles to other members"
end
