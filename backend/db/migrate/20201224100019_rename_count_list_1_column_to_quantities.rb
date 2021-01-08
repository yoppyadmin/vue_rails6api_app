class RenameCountList1ColumnToQuantities < ActiveRecord::Migration[6.0]
  def change
    rename_column :quantities, :count_list_1, :quantity_list_1
  end
end
