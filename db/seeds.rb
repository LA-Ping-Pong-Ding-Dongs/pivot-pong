# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#
# <Match id: 1, winner: "Adam", loser: "Bob", created_at: "2011-07-08 00:21:06", updated_at: "2011-07-08 00:21:06", occured_at: "2011-07-07 20:20:59">
#
adam = Player.create(name: "Adam")
bob = Player.create(name: "Bob")
carol = Player.create(name: "Carol")
dave = Player.create(name: "Dave")
ed = Player.create(name: "Ed")
t1 = Team.create(player1: ed,    player2: dave)
t2 = Team.create(player1: carol, player2: bob)
t3 = Team.create(player1: ed,    player2: adam)
t4 = Team.create(player1: carol, player2: adam)
Match.create(winner: adam, loser: bob)
Match.create(winner: t1, loser: t2)
Match.create(winner: t2, loser: t3)
Match.create(winner: bob, loser: carol)
Match.create(winner: carol, loser: dave)
Match.create(winner: t2, loser: t1)
Match.create(winner: dave, loser: ed)
Match.create(winner: adam, loser: carol)
Match.create(winner: t2, loser: t1)
Match.create(winner: adam, loser: dave)
Match.create(winner: t3, loser: t1)
Match.create(winner: t3, loser: t4)
Match.create(winner: adam, loser: ed)
