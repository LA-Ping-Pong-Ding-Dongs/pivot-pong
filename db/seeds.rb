10.times do
  name = Faker::Internet.user_name.downcase
  Player.create(key: name, name: name.upcase, mean: 1000, sigma: 1000, last_tournament_date: Date.today)
end


players = Player.all

10.times do
  winner, loser = players.sample(2)
  Match.create(winner_key: winner.key, loser_key: loser.key)
end
