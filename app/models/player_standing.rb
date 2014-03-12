class PlayerStanding
  attr_reader :key, :name, :wins, :losses, :most_recent_win, :most_recent_match

  def initialize(key, name)
    @name = name
    @key = key
    @opponents = []
    @wins = 0
    @losses = 0
    @most_recent_win = Time.new(0)
    @most_recent_match = Time.new(0)
  end

  def add_to_wins
    @wins += 1
  end

  def add_to_losses
    @losses += 1
  end

  def add_opponent(opponent_key)
    @opponents << opponent_key
  end

  def store_most_recent_win(win_time)
    unless @most_recent_win && @most_recent_win > win_time
      @most_recent_win = win_time
    end
  end

  def store_most_recent_match(match_time)
    unless @most_recent_match && @most_recent_match > match_time
      @most_recent_match = match_time
    end
  end

  def unique_opponents_count
    @opponents.uniq.count
  end

  def standings_score
    ( wins.to_f / (wins + losses)) * unique_opponents_count
  end

end
