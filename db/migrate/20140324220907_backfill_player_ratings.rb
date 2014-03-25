class BackfillPlayerRatings < ActiveRecord::Migration
  def up
    Player.update_all(['"sigma" = ?', Player::DEFAULT_SIGMA])
    Player.update_all(['"mean" = ?', Player::DEFAULT_MEAN])

    Match.order('created_at ASC').find_each do |match|
      RatingsUpdater.new.update_for_match(winner_key: match.winner_key, loser_key: match.loser_key)
    end
  end

  def down
  end
end
