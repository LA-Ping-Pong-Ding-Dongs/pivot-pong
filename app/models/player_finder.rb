class PlayerFinder
  def find_or_create_by_name(name)
    begin
      player = Player.find(name.downcase)
    rescue ActiveRecord::RecordNotFound
      player = Player.create(key: name.downcase, name: name)
    end

    OpenStruct.new(name: player.name, key: player.id)
  end

  def find_all_players
    Player.all.map { |player| OpenStruct.new(name: player.name, key: player.id) }
  end
end