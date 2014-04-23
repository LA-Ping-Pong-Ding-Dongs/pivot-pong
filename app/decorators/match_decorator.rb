class MatchDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  delegate_all
  delegate :name, to: :winner, prefix: true
  delegate :name, to: :loser, prefix: true

  def as_json
    super.merge({
      human_readable_time: human_readable_time,
      winner_name: winner_name,
      loser_name: loser_name
    })
  end

  def human_readable_time
    if object.created_at > 1.day.ago
      time_ago = time_ago_in_words(object.created_at).gsub('about ', '')
      "#{time_ago} ago"
    else
      object.created_at.strftime('%-m/%-d/%Y')
    end
  end
end
