class AddDeliveryColsToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :refilled_at, :date
    add_column :substances, :delivered_quantity, :integer
  end
end
