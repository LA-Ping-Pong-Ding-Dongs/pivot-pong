class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players, primary_key: :key, id: false do |t|
      t.string :name
      t.string :key
      t.timestamps
    end
  end
end
