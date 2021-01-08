class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.string :list_1, null: false
      t.string :list_2, null: false
      t.string :list_3, default: nil
      t.string :list_4, default: nil
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
