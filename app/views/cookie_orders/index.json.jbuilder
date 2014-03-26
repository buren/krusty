json.array!(@cookie_orders) do |cookie_order|
  json.extract! cookie_order, :id, :cookie_id, :order_id, :amount
  json.url cookie_order_url(cookie_order, format: :json)
end
