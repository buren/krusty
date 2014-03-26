class AddCookieIdToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :cookie_id, :integer
  end
end
