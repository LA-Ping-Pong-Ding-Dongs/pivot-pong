class Match < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player', foreign_key: 'winner_key', primary_key: 'key'
  belongs_to :loser, class_name: 'Player', foreign_key: 'loser_key', primary_key: 'key'

  def self.find_recent
    includes(:winner, :loser).order('created_at desc').limit(10)
  end
end
