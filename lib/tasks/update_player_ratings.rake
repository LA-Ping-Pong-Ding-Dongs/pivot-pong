desc 'Updates player ratings for all unprocessed matches'
task :update_ratings => :environment do
  PlayerRatingUpdater.new.update_for_tournament
end