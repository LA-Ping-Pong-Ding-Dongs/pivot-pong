class AddsProcessedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :processed, :boolean, default: false
  end
end
