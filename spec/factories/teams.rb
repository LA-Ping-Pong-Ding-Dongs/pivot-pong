FactoryGirl.define do
  factory :team do
    association :player1, factory: :player
    association :player2, factory: :player

    sequence(:name) { |n| "name #{n}"}
  end
end
