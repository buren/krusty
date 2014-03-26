json.array!(@cookies) do |cooky|
  json.extract! cooky, :id, :name
  json.url cooky_url(cooky, format: :json)
end
