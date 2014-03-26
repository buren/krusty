class Recipe < ActiveRecord::Base
  belongs_to :substance
  belongs_to :cookie

  validates_presence_of :substance, :quantity, :cookie

end
