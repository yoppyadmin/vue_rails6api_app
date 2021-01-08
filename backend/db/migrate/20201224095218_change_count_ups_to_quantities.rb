class ChangeCountUpsToQuantities < ActiveRecord::Migration[6.0]
  def change
    rename_table :count_ups, :quantities
  end
end
