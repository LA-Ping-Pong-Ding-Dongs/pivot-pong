class MatchForm
  include Virtus.model
  include ActiveModel::Validations

  def self.validates_dependencies *things
    validator_method_name = "validates_#{things.join('_')}"
    define_method validator_method_name do
      things.each do |thing|
        model = send(thing)
        unless model.valid?
          errors.add(thing, model.errors.full_messages.to_sentence)
        end
      end
    end
    validate validator_method_name
  end



  attribute :winner, String
  attribute :loser, String

  validates_presence_of :winner, presence: true
  validates_presence_of :loser, presence: true
  validates_dependencies :winning_player, :losing_player, :match
  validate :players_must_be_different

  def save
    if valid?
      persist!
      true
    else
      false
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
    Player.find_or_initialize_by(name: name)
  end

  def players_must_be_different
    if winning_player && losing_player && winning_player == losing_player
      errors.add(:loser, "Winner and loser can't be the same!")
    end
  end

  def persist!
    winning_player.save!
    losing_player.save!
    match.save!
  end
end
