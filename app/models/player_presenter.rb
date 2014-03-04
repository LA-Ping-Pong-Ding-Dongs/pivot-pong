class PlayerPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(player, matches, recent_matches, player_finder = PlayerFinder.new)
    @player = player
    @matches = matches
    @player_finder = player_finder
    @recent_matches = recent_matches
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
    @recent_matches.map do |match|
      if match.winner_key == @player.key
        "#{I18n.t('player.recent_matches.won')} #{match.loser_name} on #{match.created_at.to_s(:pivot_pong_time)}"
      else
        "#{I18n.t('player.recent_matches.lost')} #{match.winner_name} on #{match.created_at.to_s(:pivot_pong_time)}"
      end
    end
  end

  private

  def wins
    @matches.select { |match| match.winner_key == @player.key }
  end

  def losses
    @matches.select { |match| match.loser_key == @player.key }
  end
end