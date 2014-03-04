class ReadOnlyStruct < OpenStruct

  def method_missing(meth, *args)
    raise StandardError.new(meth.to_s)
  end
end