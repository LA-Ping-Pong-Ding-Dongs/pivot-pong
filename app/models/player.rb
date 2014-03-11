class Player < ActiveRecord::Base
  self.primary_key = :key

  def to_param
    key
  end
end
