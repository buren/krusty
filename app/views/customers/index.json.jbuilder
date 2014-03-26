json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :address, :order_id
  json.url customer_url(customer, format: :json)
end
