class PlayerCreator

  def create_player(key: , name: , mean: Player::DEFAULT_MEAN, sigma: Player::DEFAULT_SIGMA)
    player = Player.create(key: key, name: name, mean: mean, sigma: sigma)
    PlayerStruct.new(player.key, player.name, player.mean, player.sigma)
  end

end
