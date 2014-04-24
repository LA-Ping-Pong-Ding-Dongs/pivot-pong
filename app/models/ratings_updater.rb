class RatingsUpdater
  def update_for_match(winner: , loser:)
    winner_rating = Saulabs::TrueSkill::Rating.new(winner.mean.to_f, winner.sigma.to_f)
    loser_rating = Saulabs::TrueSkill::Rating.new(loser.mean.to_f, loser.sigma.to_f)

    graph = Saulabs::TrueSkill::FactorGraph.new([winner_rating] => 1, [loser_rating] => 2)
    graph.update_skills

    winner.update_attributes(mean: winner_rating.mean.round, sigma: winner_rating.deviation.round)
    loser.update_attributes(mean: loser_rating.mean.round, sigma: loser_rating.deviation.round)
  end

end
