class Team < Opponent
  attr_accessible :player1, :player2, :name

  belongs_to :player1, class_name: Player.name, autosave: true
  belongs_to :player2, class_name: Player.name, autosave: true

  validates :name, uniqueness: true, allow_blank: true
  validates :player1, :presence => true
  validates :player2, :presence => true

  def to_s
    name.present? ? "#{name.titleize}" : "#{player1} & #{player2}"
  end
end
