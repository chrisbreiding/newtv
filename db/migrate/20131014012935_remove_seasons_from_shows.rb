class RemoveSeasonsFromShows < ActiveRecord::Migration
  def up
    remove_column :shows, :seasons
  end

  def down
    add_column :shows, :seasons, :integer
  end
end
