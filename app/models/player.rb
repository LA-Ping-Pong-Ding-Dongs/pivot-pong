class Player < ActiveRecord::Base
  DEFAULT_MEAN = 1000
  DEFAULT_SIGMA = 200

  self.primary_key = :key
  validates :name, presence: true, uniqueness: true
  validates :key, presence: true, uniqueness: true

  before_validation :ensure_required_fields

  has_many :winning_matches, class_name: 'Match', primary_key: 'key', foreign_key: 'winner_key'
  has_many :losing_matches, class_name: 'Match', primary_key: 'key', foreign_key: 'loser_key'

  has_many :winning_tournaments, class_name: 'Tournament', primary_key: 'key', foreign_key: 'winner_key'

  def self.find_or_initialize_by_lower_name(name)
    where('LOWER(name) = ?', name.downcase).first || new(name: name)
  end

  def self.find_by_substring(substr)
    where('name ILIKE ?', "#{substr}%").order('name ASC')
  end

  def recent_matches
    matches.limit(10)
  end

  def matches
    Match.where('matches.winner_key = ? OR matches.loser_key = ?', key, key).order('created_at desc')
  end

  def to_param
    key
  end

  def ensure_required_fields
    self.key ||= SecureRandom.uuid
  end

  def mean
    read_attribute(:mean) || DEFAULT_MEAN
  end

  def sigma
    read_attribute(:sigma) || DEFAULT_SIGMA
  end
end
