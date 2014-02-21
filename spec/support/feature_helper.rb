module FeatureHelper
  def step(name, **options, &block)
    if options[:current]
      options[:current] << name
    end

    yield
  end
end