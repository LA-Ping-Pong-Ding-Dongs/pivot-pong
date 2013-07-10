class Opponent < ActiveRecord::Base
  before_validation :downcase_name

  private

  def downcase_name
    self.name = self.name.presence.try(:downcase)
  end
end
