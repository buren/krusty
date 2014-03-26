class AddQuantityToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :quantity, :integer
  end
end
