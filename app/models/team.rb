class Team < Opponent
  attr_accessible :player1, :player2

  belongs_to :player1, class_name: Player.name
  belongs_to :player2, class_name: Player.name
end
