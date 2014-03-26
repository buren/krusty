class AddQuantityToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :quantity, :integer
  end
end
