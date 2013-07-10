class Player < Opponent
  has_many :teams

  validates :name, presence: true, uniqueness: true

  def to_s
    name.split("'").map(&:titleize).join("'")
  end
end
