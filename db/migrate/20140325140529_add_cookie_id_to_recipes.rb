class AddCookieIdToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :cookie_id, :integer
  end
end
