class PlayerRatingUpdater
  def initialize(
    match_finder = MatchFinder.new,
    player_finder = PlayerFinder.new,
    param_builder = NttrsParamBuilder.new,
    player_updater = PlayerUpdater.new,
    match_updater = MatchUpdater.new
  )
    @param_builder = param_builder
    @match_finder = match_finder
    @player_finder = player_finder
    @player_updater = player_updater
    @match_updater = match_updater
  end

  def update_for_tournament
    players = @player_finder.find_all_players
    matches = @match_finder.find_unprocessed

    results = Nttrs::Tournament.new(@param_builder.build_player_data(players), @param_builder.build_match_data(matches)).final_player_laws

    results.each do |player|
      @player_updater.update_for_player(player[:id], player[:law])
    end

    matches.each { |match| @match_updater.mark_as_processed(match.id) }
  end
end
