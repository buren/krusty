class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.integer :order_id

      t.timestamps
    end
  end
end
