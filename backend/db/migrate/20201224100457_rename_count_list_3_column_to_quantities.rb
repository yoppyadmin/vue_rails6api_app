class RenameCountList3ColumnToQuantities < ActiveRecord::Migration[6.0]
  def change
    rename_column :quantities, :count_list_3, :quantity_list_3
  end
end
