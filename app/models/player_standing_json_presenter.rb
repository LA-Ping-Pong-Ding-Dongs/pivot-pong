class PlayerStandingJsonPresenter

  def initialize(player_standing)
    @player_standing = player_standing
  end

  def as_json
    {
      key: @player_standing.key,
      name: @player_standing.name,
      wins: @player_standing.wins,
      losses: @player_standing.losses,
    }
  end
end
