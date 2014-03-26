class Cookie < ActiveRecord::Base
  has_many :recipes
  has_many :pallets
  has_many :cookie_orders
end
