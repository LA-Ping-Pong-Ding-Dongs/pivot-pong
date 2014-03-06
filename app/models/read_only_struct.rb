class ReadOnlyStruct < OpenStruct

  def to_ary
    nil
  end

  def to_json
    to_h.to_json
  end

  def as_json
    to_h
  end

  def method_missing(meth, *args)
    raise StandardError.new(meth.to_s)
  end
end
