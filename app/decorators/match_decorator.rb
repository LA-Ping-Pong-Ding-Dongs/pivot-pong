class MatchDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  delegate_all

  def as_json
    object.to_h.merge({
      human_readable_time: human_readable_time,
    })
  end

  def human_readable_time
    if @match.created_at > 1.day.ago
      time_ago = time_ago_in_words(@match.created_at).gsub('about ', '')
      "#{time_ago} ago"
    else
      @match.created_at.strftime('%-m/%-d/%Y')
    end
  end

end
