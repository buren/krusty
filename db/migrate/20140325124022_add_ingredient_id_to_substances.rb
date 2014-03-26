class AddIngredientIdToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :ingredient_id, :integer
  end
end
