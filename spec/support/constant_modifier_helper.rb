module ConstantModifierHelper
  def execute_with_modified_constant(klass, constant, value)
    original_value = klass.const_get(constant)
    Kernel.silence_warnings do
      klass.const_set(constant, value)
    end
    yield
  ensure
    Kernel.silence_warnings do
      klass.const_set(constant, original_value)
    end
  end
end