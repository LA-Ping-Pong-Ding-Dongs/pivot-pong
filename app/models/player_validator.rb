class PlayerValidator
  include ActiveModel::Validations
  attr_reader :key, :name

  def initialize(params)
    @key = params[:key]
    @name = params[:name]
  end

  validates_presence_of :key
  validates_presence_of :name
  validate :unique_name?
  validate :key_record_exists?

  private

  def unique_name?
    if Player.where('LOWER(name) = LOWER(?)', name).exists?
      self.errors.add(:name, 'name already exists. Please select a unique name.')
    end
  end

  def key_record_exists?
    if Player.where('key = ?', key).count == 0
      self.errors.add(:key, 'user does not exist.')
    end
  end

end