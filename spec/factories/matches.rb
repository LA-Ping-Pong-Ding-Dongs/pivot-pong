FactoryGirl.define do
  factory :match do
    association :winner, factory: :player
    association :loser, factory: :player
  end

  factory :doubles_match, class: :match do
    association :winner, factory: :team
    association :loser, factory: :team
  end
end
