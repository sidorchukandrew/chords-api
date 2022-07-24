json.array! @setlists do |setlist|
  json.(setlist, :created_at, :updated_at, :name, :scheduled_date, :team_id)

  json.songs setlist.songs do |song|
    json.(song, :id, :created_at, :updated_at, :name)
  end
end

