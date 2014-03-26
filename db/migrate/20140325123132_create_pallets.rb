class CreatePallets < ActiveRecord::Migration
  def change
    create_table :pallets do |t|
      t.boolean :is_blocked
      t.integer :order_id

      t.timestamps
    end
  end
end
