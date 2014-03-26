class RemoveQuantityFromPallets < ActiveRecord::Migration
  def change
    remove_column :pallets, :quantity, :ingeter
  end
end
