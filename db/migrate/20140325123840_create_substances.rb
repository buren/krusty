class CreateSubstances < ActiveRecord::Migration
  def change
    create_table :substances do |t|
      t.string :name
      t.integer :quantity

      t.timestamps
    end
  end
end
