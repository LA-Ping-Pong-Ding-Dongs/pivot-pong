class PlayerDecorator < Draper::Decorator
  delegate_all

  def overall_winning_percentage
    percent = 100.0 * winning_matches.count / matches.count
    h.number_to_percentage(percent, precision: 1)
  end

  def overall_record_string
    [winning_matches.count, losing_matches.count].join('-')
  end

  def current_streak_type
    match = object.recent_matches.try(:first)
    return unless match
    match.winner_key == key ? 'W' : 'L'
  end

  def current_streak_string
    [streak_count, current_streak_type].join
  end

  def current_streak_totem_image
    img = nil
    if streak_type == 'winner'
      img = 'smoke.png' if streak_count == 2
      img = 'fire.png' if streak_count > 2
    elsif streak_type == 'loser'
      img = 'ice.png' if streak_count > 2
    end

    img ? h.image_path(img) : ''
  end

  def streak_count
    return nil unless matches.first
    return @streak if @streak
    @streak = 1
    matches.each_with_index do |match, index|
      if match.send("#{streak_type}_key") == player.key
        @streak = index + 1
      else
        break
      end
    end

    @streak
  end

  def recent_matches
    object.recent_matches.decorate.map do |match|
      if match.winner_key == key
        result = "#{I18n.t('player.recent_matches.won')} #{match.loser_name}"
      else
        result = "#{I18n.t('player.recent_matches.lost')} #{match.winner_name}"
      end

      "#{result} #{I18n.t('player.recent_matches.on_date')} #{match.human_date}"
    end
  end

  def streak_type
    return nil unless matches.first

    if matches.first.winner_key == key
      'winner'
    else
      'loser'
    end
  end

  def tournament_win_count
    winning_tournaments.count
  end

  def as_json(options = nil)
    {
        name: name,
        overall_losses: losing_matches.count,
        overall_wins: winning_matches.count,
        current_streak_count: streak_count,
        current_streak_type: current_streak_type,
        current_streak_totem_image: current_streak_totem_image,
        rating: mean,
        overall_winning_percentage: overall_winning_percentage,
    }
  end
end
