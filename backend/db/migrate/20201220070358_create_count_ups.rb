class CreateCountUps < ActiveRecord::Migration[6.0]
  def change
    create_table :count_ups do |t|
      t.integer :count_list_1, default: 0
      t.integer :count_list_2, default: 0
      t.integer :count_list_3, default: 0
      t.integer :count_list_4, default: 0
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
