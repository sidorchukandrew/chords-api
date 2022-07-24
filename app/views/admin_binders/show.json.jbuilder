json.(@binder, :name, :description, :color, :created_at, :updated_at, :id)

json.songs @binder.songs do |song|
    json.(song, :name, :id, :created_at, :updated_at)
end