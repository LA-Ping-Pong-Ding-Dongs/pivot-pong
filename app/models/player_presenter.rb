class PlayerPresenter
  RECENT_MATCH_LIMIT = 5

  include ActionView::Helpers::NumberHelper

  def initialize(player, matches, player_finder = PlayerFinder.new)
    @player = player
    @matches = matches
    @player_finder = player_finder
  end

  def overall_winning_percentage
    percent = 100.0 * wins.count / @matches.count
    number_to_percentage(percent, precision: 1)
  end

  def overall_record
    "#{wins.count}-#{losses.count}"
  end

  def name
    @player.name
  end

  def recent_matches
    @matches[0..(RECENT_MATCH_LIMIT - 1)].map do |match|
      if match.winner_key == @player.key
        won_lost = 'Beat'
        opponent = @player_finder.find(match.loser_key).name
      else
        won_lost = 'Lost to'
        opponent = @player_finder.find(match.winner_key).name
      end
      "#{won_lost} #{opponent} on #{match.created_at.to_s(:pivot_pong_time)}"
    end
  end

  private

  def wins
    @matches.select{|match| match.winner_key == @player.key}
  end

  def losses
    @matches.select{|match| match.loser_key == @player.key}
  end
end