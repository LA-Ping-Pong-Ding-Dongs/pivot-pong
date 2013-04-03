FactoryGirl.define do
  factory :team do
    association :player1, factory: :player
    association :player2, factory: :player
  end
end
