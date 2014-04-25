class MatchDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  delegate_all

  def human_readable_time
    if object.created_at > 1.day.ago
      time_ago = time_ago_in_words(object.created_at).gsub('about ', '')
      "#{time_ago} ago"
    else
      object.created_at.strftime('%-m/%-d/%Y')
    end
  end

  def human_date
    match.created_at.to_s(:pivot_pong_time)
  end

  def winner_name
    object.winner.try(:name)
  end

  def loser_name
    object.loser.try(:name)
  end
end
