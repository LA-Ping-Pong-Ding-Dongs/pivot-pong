class Team < Opponent
  attr_accessible :player1, :player2

  belongs_to :player1, class_name: Player.name
  belongs_to :player2, class_name: Player.name

  def to_s
    "#{player1} and #{player2}"
  end
end
