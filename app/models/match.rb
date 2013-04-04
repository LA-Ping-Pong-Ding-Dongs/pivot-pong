class Match < ActiveRecord::Base
  validates :winner,      presence: true
  validates :loser,       presence: true

  belongs_to :winner, :class_name => Opponent.name
  belongs_to :loser, :class_name => Opponent.name

  before_validation :set_default_occured_at_date, on: :create, :unless => ->{ occured_at.present? }

  def self.doubles_matches
    scoped
  end

  private

  def set_default_occured_at_date
    self.occured_at = Time.now
  end
end
