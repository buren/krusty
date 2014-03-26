json.array!(@orders) do |order|
  json.extract! order, :id, :requested_delivery_date, :delivered_date
  json.url order_url(order, format: :json)
end
