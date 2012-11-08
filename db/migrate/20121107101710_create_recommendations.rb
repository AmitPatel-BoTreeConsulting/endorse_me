class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :name
      t.string :title
      t.string :photo_url
      t.string :company
      t.text :recommendation
      t.string :source
      t.string :ref_id
      t.integer :user_id

      t.timestamps
    end

    add_index :recommendations, [:user_id]

  end
end
