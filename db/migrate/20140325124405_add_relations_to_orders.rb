class AddRelationsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pallet_id, :integer
    add_column :orders, :customer_id, :integer
  end
end
