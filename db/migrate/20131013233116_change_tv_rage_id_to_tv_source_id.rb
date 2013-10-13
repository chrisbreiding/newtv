class ChangeTvRageIdToTvSourceId < ActiveRecord::Migration
  def change
    rename_column :shows, :tvrage_id, :tvsource_id
  end
end
