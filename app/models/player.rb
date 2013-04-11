class Player < Opponent
  before_validation :downcase_name, :if => ->{ name.present? }

  validates :name, presence: true, uniqueness: true

  def to_s
    name.split("'").map(&:titleize).join("'")
  end

  private

  def downcase_name
    self.name = self.name.downcase
  end
end
