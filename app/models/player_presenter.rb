class PlayerPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(player, matches, recent_matches, player_finder = PlayerFinder.new)
    @player = player
    @matches = matches
    @player_finder = player_finder
    @recent_matches = recent_matches
  end

  def overall_winning_percentage
    percent = 100.0 * wins(@matches).count / @matches.count
    number_to_percentage(percent, precision: 1)
  end

  def overall_losses
    losses(@matches).count
  end

  def overall_wins
    wins(@matches).count
  end

  def overall_record_string
    "#{overall_wins}-#{overall_losses}"
  end

  def current_streak_type
    string_map = {
        'winner' => I18n.t('player.streak.type.winner'),
        'loser' => I18n.t('player.streak.type.loser'),
    }
    string_map[streak_type(@matches, @player)]
  end

  def current_streak_count
    type = streak_type(@matches, @player)
    streak_count(@matches, @player, type)
  end

  def current_streak_string
    return '' unless @matches.first

    "#{current_streak_count}#{current_streak_type}"
  end

  def name
    @player.name
  end

  def recent_matches
    @recent_matches.map do |match|
      if match.winner_key == @player.key
        "#{I18n.t('player.recent_matches.won')} #{match.loser_name} #{I18n.t('player.recent_matches.on_date')} #{match.created_at.to_s(:pivot_pong_time)}"
      else
        "#{I18n.t('player.recent_matches.lost')} #{match.winner_name} #{I18n.t('player.recent_matches.on_date')} #{match.created_at.to_s(:pivot_pong_time)}"
      end
    end
  end

  def as_json
    {
        name: name,
        overall_losses: overall_losses,
        overall_wins: overall_wins,
        current_streak_count: current_streak_count,
        current_streak_type: current_streak_type,
        rating: @player.mean,
        overall_winning_percentage: overall_winning_percentage,
    }
  end

  private

  def wins(matches)
    matches.select { |match| match.winner_key == @player.key }
  end

  def losses(matches)
    matches.select { |match| match.loser_key == @player.key }
  end

  def streak_count(matches, player, type)
    return nil unless matches.first

    streak = 1
    matches.each_with_index do |match, index|
      if match.send("#{type}_key") == player.key
        streak = index + 1
      else
        break
      end
    end

    streak
  end

  def streak_type(matches, player)
    return nil unless matches.first

    if matches.first.winner_key == player.key
      'winner'
    else
      'loser'
    end
  end

end