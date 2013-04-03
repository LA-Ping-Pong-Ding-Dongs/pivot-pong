FactoryGirl.define do
  factory :match do
    association :winner, factory: :player
    association :loser, factory: :player
  end
end
