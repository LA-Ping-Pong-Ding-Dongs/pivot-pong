class AddMeanToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :mean, :integer
    add_column :players, :sigma, :integer
    add_column :players, :last_tournament_date, :date
  end
end
