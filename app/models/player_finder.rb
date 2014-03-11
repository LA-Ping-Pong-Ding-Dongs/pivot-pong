class PlayerFinder
  def find_or_create_by_name(name)
    begin
      player = Player.find(name.downcase)
    rescue ActiveRecord::RecordNotFound
      player = Player.create(key: name.downcase, name: name)
    end

    player_to_struct(player)
  end

  def find_all_players
    Player.all.map { |player| player_to_struct(player) }
  end

  def find(key)
    player = Player.find(key)
    player_to_struct(player)
  end

  private

  def player_to_struct(player)
    PlayerStruct.new(player.key, player.name, player.mean, player.sigma)
  end
end