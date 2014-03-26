class CreateCookieOrders < ActiveRecord::Migration
  def change
    create_table :cookie_orders do |t|
      t.integer :cookie_id
      t.integer :order_id
      t.integer :amount

      t.timestamps
    end
  end
end
