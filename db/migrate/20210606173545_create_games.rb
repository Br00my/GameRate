class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :picture, null: false
      t.string :genres, null: false
      t.float :rate

      t.timestamps
    end
  end
end
