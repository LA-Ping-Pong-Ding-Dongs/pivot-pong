class BaseFactory
  include Virtus.model
  include ActiveModel::Validations

  def self.validates_dependencies *things
    validator_method_name = "validates_#{things.join('_')}"
    define_method validator_method_name do
      things.each do |thing|
        model = send(thing)
        unless model.valid?
          errors.add(thing, model.errors.full_messages.to_sentence)
        end
      end
    end
    validate validator_method_name
  end


  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def as_json options = {}
    if errors.any?
      super.merge(errors: errors)
    else
      super
    end
  end

  def error_messages
    errors.full_messsages
  end

  private
  def persist!
    raise NotImplementedError, 'Subclasses of BaseService need to implement #persist!'
  end
end
