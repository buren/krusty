class AddSubstanceIdToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :substance_id, :integer
  end
end
