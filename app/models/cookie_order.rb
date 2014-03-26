class CookieOrder < ActiveRecord::Base
  belongs_to :cookie
  belongs_to :order
end
