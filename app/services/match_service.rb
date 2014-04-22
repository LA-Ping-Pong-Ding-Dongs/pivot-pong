class MatchService < BaseService
  attribute :winner, String
  attribute :loser, String

  validates_presence_of :winner, presence: true
  validates_presence_of :loser, presence: true
  validates_dependencies :winning_player, :losing_player, :match
  validate :players_must_be_different

  def as_json options = {}
    if errors.any?
      super.merge(errors: errors)
    else
      super
    end
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
    if winning_player && losing_player && winning_player == losing_player
      errors.add(:loser, "can't be the same name as winner!")
    end
  end

  def persist!
    winning_player.save!
    losing_player.save!
    match.save!
  end
end
