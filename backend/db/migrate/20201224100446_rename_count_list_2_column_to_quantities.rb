class RenameCountList2ColumnToQuantities < ActiveRecord::Migration[6.0]
  def change
    rename_column :quantities, :count_list_2, :quantity_list_2
  end
end
