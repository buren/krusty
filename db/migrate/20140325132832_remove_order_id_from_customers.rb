class RemoveOrderIdFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :order_id, :integer
  end
end
