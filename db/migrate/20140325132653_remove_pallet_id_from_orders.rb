class RemovePalletIdFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :pallet_id, :integer
  end
end
