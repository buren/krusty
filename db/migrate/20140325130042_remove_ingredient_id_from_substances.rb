class RemoveIngredientIdFromSubstances < ActiveRecord::Migration
  def change
    remove_column :substances, :ingredient_id, :integer
  end
end
