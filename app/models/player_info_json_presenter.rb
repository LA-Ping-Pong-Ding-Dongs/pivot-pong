class PlayerInfoJsonPresenter

  def initialize(player, matches)
    @player = player
    @matches = matches
  end

  def overall_losses
     losses.count
  end

  def overall_wins
    wins.count
  end

  def as_json
    {
        name: @player.name,
        overall_losses: overall_losses,
        overall_wins: overall_wins,
        rating: @player.mean,
    }
  end

  private

  def losses
    @losses ||= @matches.select{ |match| match.loser_key == @player.key }
  end

  def wins
    @wins ||= @matches.select{ |match| match.winner_key == @player.key }
  end
end