class MatchDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  delegate_all

  def human_readable_time
    if created_at > 1.day.ago
      time_ago = time_ago_in_words(created_at).gsub('about ', '')
      "#{time_ago} ago"
    else
      created_at.strftime('%-m/%-d/%Y')
    end
  end

  def human_date
    created_at.to_s(:pivot_pong_time)
  end

  def winner_name
    winner.try(:name)
  end

  def loser_name
    loser.try(:name)
  end
end
