class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :text
      t.integer :rate
      t.integer :multiplier

      t.timestamps
    end
  end
end
