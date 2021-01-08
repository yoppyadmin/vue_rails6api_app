class RenameCountList4ColumnToQuantities < ActiveRecord::Migration[6.0]
  def change
    rename_column :quantities, :count_list_4, :quantity_list_4
  end
end
