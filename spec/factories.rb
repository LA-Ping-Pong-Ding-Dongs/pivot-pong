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

end