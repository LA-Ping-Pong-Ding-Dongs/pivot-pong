require 'rspec/expectations'

RSpec::Matchers.define :equal_structs do |expected|
  match do |actual|
    actual.map{ |s| s.to_h.tap{ |h| h.delete(:created_at) } } == expected.map{ |s| s.to_h.tap{ |h| h.delete(:created_at) } } &&
        actual.map{ |s| s.class } == expected.map{ |s| s.class } &&
        ! actual.map{ |s| s.kind_of?(Struct) }.include?(false)
  end
end