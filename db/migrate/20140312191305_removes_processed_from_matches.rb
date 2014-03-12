class RemovesProcessedFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :processed
  end
end
