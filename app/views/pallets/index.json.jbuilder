json.array!(@pallets) do |pallet|
  json.extract! pallet, :id, :is_blocked, :order_id
  json.url pallet_url(pallet, format: :json)
end
