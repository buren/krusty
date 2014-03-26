class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :pallets
  has_many :cookie_orders
  has_many :cookies, through: :cookie_orders

  validates_presence_of :requested_delivery_date, :customer


  def blocked?
    self.is_blocked
  end

end
