class AddLocationToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :location, :string
  end
end
