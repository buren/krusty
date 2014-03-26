json.array!(@substances) do |substance|
  json.extract! substance, :id, :name, :quantity
  json.url substance_url(substance, format: :json)
end
