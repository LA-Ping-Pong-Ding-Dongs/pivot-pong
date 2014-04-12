class ConvertPlayerKeyFromNameToUuid < ActiveRecord::Migration
  def up
    keys = get_player_key_and_name
    keys.each do |name_key_hash|
      old_key = name_key_hash["key"]
      new_key = SecureRandom.uuid

      execute <<-UPDATE_PLAYER_KEY
      UPDATE players
      SET key = '#{new_key}'
      WHERE key = '#{old_key}'
      UPDATE_PLAYER_KEY

      execute <<-UPDATE_WINNERS
      UPDATE matches
      SET winner_key = '#{new_key}'
      WHERE winner_key = '#{old_key}'
      UPDATE_WINNERS

      execute <<-UPDATE_LOSERS
      UPDATE matches
      SET loser_key = '#{new_key}'
      WHERE loser_key = '#{old_key}'
      UPDATE_LOSERS
    end
  end

  def down
    keys = get_player_key_and_name

    keys.each do |name_key_hash|
      execute <<-UPDATE_WINNERS
      UPDATE matches
      SET winner_key = '#{name_key_hash['name']}'
      WHERE winner_key = '#{name_key_hash['key']}'
      UPDATE_WINNERS

      execute <<-UPDATE_LOSERS
      UPDATE matches
      SET loser_key = '#{name_key_hash['name']}'
      WHERE loser_key = '#{name_key_hash['key']}'
      UPDATE_LOSERS
    end

    execute <<-UPDATE_PLAYERS
      UPDATE players
      SET key = name
    UPDATE_PLAYERS
  end

  def get_player_key_and_name
    execute <<-GET_KEYS
      SELECT key, name
      FROM players
    GET_KEYS
  end
end
