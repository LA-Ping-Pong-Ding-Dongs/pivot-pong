FactoryGirl.define do

  factory :player do
    sequence :name do |n|
      "Player #{n}"
    end
    key { self.name.downcase }
    mean { rand(3000) }
    sigma { rand(200) }
    last_tournament_date { Date.today }
  end

  factory :match do
    sequence :winner_key do |n|
      "winner#{n}"
    end
    sequence :loser_key do |n|
      "loser#{n}"
    end
    created_at { Time.now }
  end

end