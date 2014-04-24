class RatingsUpdater

  def initialize(player_finder = PlayerFinder.new, player_updater = PlayerUpdater.new)
    @player_finder = player_finder
    @player_updater = player_updater
  end

  def update_for_match(winner_key: , loser_key:)
    winner = @player_finder.find(winner_key)
    loser = @player_finder.find(loser_key)

    winner_rating = Saulabs::TrueSkill::Rating.new(winner.mean, winner.sigma)
    loser_rating = Saulabs::TrueSkill::Rating.new(loser.mean, loser.sigma)

    graph = Saulabs::TrueSkill::FactorGraph.new([winner_rating] => 1, [loser_rating] => 2)
    graph.update_skills

    @player_updater.update_for_player(winner.key, { mean: winner_rating.mean.round, sigma: winner_rating.deviation.round })
    @player_updater.update_for_player(loser.key, { mean: loser_rating.mean.round, sigma: loser_rating.deviation.round })
  end

end
