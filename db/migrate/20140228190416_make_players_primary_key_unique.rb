class MakePlayersPrimaryKeyUnique < ActiveRecord::Migration
  def up
    add_index(:players, :key, unique: true)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
