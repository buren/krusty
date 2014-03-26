json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :pallet_id, :ingredient_id
  json.url recipe_url(recipe, format: :json)
end
