class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :winner_key
      t.string :loser_key

      t.timestamps
    end
  end
end
