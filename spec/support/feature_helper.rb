module FeatureHelper
  def step(name, **options, &block)
    if options[:current]
      options[:current] << name
    end

    yield
  end

  def self.included(base)
    base.class_eval do
      self.use_transactional_fixtures = false
    end
  end
end