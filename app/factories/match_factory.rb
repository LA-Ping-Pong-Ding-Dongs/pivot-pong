class MatchFactory < BaseFactory
  attribute :winner, String
  attribute :loser, String

  validates_presence_of :winner, presence: true
  validates_presence_of :loser, presence: true
  validates_dependencies :winning_player, :losing_player, :match
  validate :players_must_be_different

  # allow polymorphic_route to work so we don't have to override base_controller
  def to_model
    match
  end

  private

  def winning_player
    @winning_player ||= find_player(winner)
  end

  def losing_player
    @losing_player ||= find_player(loser)
  end

  def match
    @match ||= Match.new(winner: winning_player, loser: losing_player)
  end

  def find_player(name)
    Player.find_or_initialize_by_lower_name(name)
  end

  def players_must_be_different
    if winner && loser && winner == loser
      errors.add(:loser, "can't be the same name as winner!")
    end
  end

  def persist!
    winning_player.save!
    losing_player.save!
    match.save!
    RatingsUpdater.new.update_for_match(winner: winning_player, loser: losing_player)
  end
end
