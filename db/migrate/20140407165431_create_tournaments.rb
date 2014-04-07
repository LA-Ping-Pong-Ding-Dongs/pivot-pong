class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :winner_key

      t.timestamps
    end
  end
end
