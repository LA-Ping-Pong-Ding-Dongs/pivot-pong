class Match < ActiveRecord::Base

  def to_struct
    ReadOnlyStruct.new(attributes)
  end

end
