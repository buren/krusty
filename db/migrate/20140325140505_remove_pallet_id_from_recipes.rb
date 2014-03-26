class RemovePalletIdFromRecipes < ActiveRecord::Migration
  def change
    remove_column :recipes, :pallet_id, :integer
  end
end
