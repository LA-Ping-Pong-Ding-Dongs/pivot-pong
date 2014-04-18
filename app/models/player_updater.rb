class PlayerUpdater

  def update_for_player(player_key, attrs)
    player = Player.find(player_key)
    player.update_attributes!(attrs)
  end

end
