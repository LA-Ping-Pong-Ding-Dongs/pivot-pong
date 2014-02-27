class MatchValidator
  include ActiveModel::Validations

  def initialize(params)
    @winner = params[:winner]
    @loser = params[:loser]
  end
  attr_reader :winner, :loser

  validates :winner, presence: true
  validates :loser, presence: true
end