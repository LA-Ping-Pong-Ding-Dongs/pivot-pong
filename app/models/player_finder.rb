class PlayerFinder
  def find_or_create_by_name(name)
    begin
      player = Player.find(name.downcase)
    rescue ActiveRecord::RecordNotFound
      player = Player.create(key: name.downcase, name: name)
    end

    player.to_struct
  end

  def find_all_players
    Player.all.map { |player| player.to_struct }
  end

  def find(key)
    Player.find(key).to_struct
  end
end