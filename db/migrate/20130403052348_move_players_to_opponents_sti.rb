class MovePlayersToOpponentsSti < ActiveRecord::Migration
  def up
    rename_table :players, :opponents
    add_column :opponents, :type, :string
    add_column :opponents, :player1_id, :integer
    add_column :opponents, :player2_id, :integer

    execute <<-SQL
      UPDATE opponents SET type = 'Player'
    SQL
  end

  def down
    remove_column :opponents, :player2_id
    remove_column :opponents, :player1_id
    remove_column :opponents, :type
    rename_table :opponents, :players
  end
end
