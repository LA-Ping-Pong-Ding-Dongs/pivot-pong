class DowncaseTeamNames < ActiveRecord::Migration
  def up
    Opponent.find_each do |o|
      lower_name = o.name.try(:downcase)
      o.update_attribute(:name, lower_name)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
