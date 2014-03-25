class Player < ActiveRecord::Base
  DEFAULT_MEAN = 1000
  DEFAULT_SIGMA = 200

  self.primary_key = :key

  def to_param
    key
  end
end
