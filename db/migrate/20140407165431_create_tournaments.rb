class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :winner_key

      t.timestamps
    end
  end
end
