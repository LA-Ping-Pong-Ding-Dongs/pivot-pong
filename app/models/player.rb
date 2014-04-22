class Player < ActiveRecord::Base
  DEFAULT_MEAN = 1000
  DEFAULT_SIGMA = 200

  self.primary_key = :key

  before_create :ensure_requried_fields

  def self.find_or_initialize_by_lower_name(name)
    where('LOWER(name) = ?', name.downcase).first || new(name: name)
  end

  def to_param
    key
  end

  def ensure_requried_fields
    self.key ||= SecureRandom.uuid
  end
end
