class AddIndexToEpisodesAirdate < ActiveRecord::Migration
  def change
    add_index :episodes, :airdate
  end
end
