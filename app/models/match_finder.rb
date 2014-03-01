class MatchFinder
  def find_all_for_player(player_key)
    Match.where('winner_key = ? OR loser_key = ?', player_key, player_key).order('created_at DESC').map do |match|
      OpenStruct.new(match.attributes)
    end
  end
end