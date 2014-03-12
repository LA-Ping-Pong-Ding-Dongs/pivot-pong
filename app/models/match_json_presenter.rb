class MatchJsonPresenter
  include ActionView::Helpers::DateHelper

  attr_reader :match
  private :match

  def initialize(match)
    @match = match
  end

  def as_json
    @match.to_h.merge({
      human_readable_time: human_readable_time,
    })
  end

  private

  delegate :winner_name, :winner_key, :loser_name, :loser_key, :created_at, to: :match

  def human_readable_time
    if @match.created_at > 1.day.ago
      time_ago = time_ago_in_words(@match.created_at).gsub('about ', '')
      "#{time_ago} ago"
    else
      @match.created_at.strftime('%-m/%-d/%Y')
    end
  end

end
