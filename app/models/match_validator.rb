class MatchValidator
  include ActiveModel::Validations

  def initialize(params)
    @winner = params[:winner]
    @loser = params[:loser]
  end
  attr_reader :winner, :loser

  validates :winner, presence: true
  validates :loser, presence: true
  validate :unique_players

  private

  def unique_players
    if @winner && @loser && @winner.downcase == @loser.downcase
      self.errors.add(:loser, 'cannot be the same player as winner')
    end
  end

end
