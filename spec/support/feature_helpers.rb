module FeatureHelpers

  def by(description, &block)
    yield
  end

  alias :and_by :by

end
